require File.dirname(__FILE__) + '/../test_helper'

class DownloadsControllerTest < ActionController::TestCase

	def teardown
		#	destroy so that files are deleted
		Download.destroy_all
	end

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){ get :new }
	end

#	test "should NOT have edit route" do
#		assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
#	end
#
#	test "should NOT have update route" do
#		assert_raise(ActionController::RoutingError){ put :update, :id => 1, :download => Factory.attributes_for(:download) }
#	end

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
		assert_nil assigns(:downloads)
	end

	test "should get index with login" do
		download = Factory(:download)
		login_as download.user
		get :index
		assert_response :success
		assert_template 'index'
		assert_not_nil assigns(:downloads)
	end

	test "should NOT create download without login" do
		assert_no_difference('Download.count') {
		assert_no_difference('BdrbJobQueue.count') {
			post :create, :download => Factory.attributes_for(:download)
		} }
		assert_redirected_to login_path
	end

	test "should create download with login" do
		login_as active_user
		assert_difference('Download.count') {
		assert_difference('BdrbJobQueue.count') {
			post :create, :download => Factory.attributes_for(:download)
		} }
		assert_redirected_to download_path(assigns(:download))
	end

	test "should NOT create download with login when save fails" do
		Download.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(Download.new))
		login_as active_user
		assert_no_difference('Download.count') {
		assert_no_difference('BdrbJobQueue.count') {
			post :create, :download => Factory.attributes_for(:download)
		} }
		assert_not_nil flash[:error]
		assert_redirected_to mystuff_path
	end

	test "should NOT show download without login" do
		download = Factory(:download)
		get :show, :id => download.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT show download without owner login" do
		download = Factory(:download)
		login_as active_user
		get :show, :id => download.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show download with owner login" do
#		Download.any_instance.stubs(:trigger_build).returns(true)	#	skip creation of pdf
		download = Factory(:download)
		login_as download.user
		get :show, :id => download.id
		assert_response :success
		assert_template 'show'
	end

	test "should show download with admin login" do
#		Download.any_instance.stubs(:trigger_build).returns(true)	#	skip creation of pdf
		download = Factory(:download)
		login_as admin_user
		get :show, :id => download.id
		assert_response :success
		assert_template 'show'
	end

	test "should NOT download incomplete download with owner login" do
		download = Factory(:download)
		login_as download.user
		get :download, :id => download.id
		assert_response :success
		assert_template 'show'
	end

	test "should download completed download with owner login" do
		download = Factory(:download)
		download.start_build
		login_as download.user
		DownloadsController.skip_after_filter :check_for_javascript
		get :download, :id => download.id
		assert_response :success
#		assert @response.body.include?("Creator (Prawn)")	#only works for "dispostion: inline"
		assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*pdf/)
	end

	test "should NOT destroy download without login" do
		download = Factory(:download)
		assert_no_difference('Download.count') {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy download without owner login" do
		download = Factory(:download)
		login_as active_user
		assert_no_difference('Download.count') {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy download with owner login via html" do
		download = Factory(:download)
		login_as download.user
		assert_difference('Download.count', -1) {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_redirected_to downloads_path
	end

	test "should destroy download with owner login via js" do
		download = Factory(:download)
		login_as download.user
		wants :js
		assert_difference('Download.count', -1) {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_response :success
		assert_select_rjs :remove, "#download_#{assigns(:download).id}"
	end

	test "should destroy download with admin login via html" do
		download = Factory(:download)
		login_as admin_user
		assert_difference('Download.count', -1) {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_redirected_to downloads_path
	end

	test "should destroy download with admin login via js" do
		download = Factory(:download)
		login_as admin_user
		wants :js
		assert_difference('Download.count', -1) {
		assert_no_difference('BdrbJobQueue.count') {
			delete :destroy, :id => download.id
		} }
		assert_response :success
		assert_select_rjs :remove, "#download_#{assigns(:download).id}"
	end

	test "should NOT get edit download without login" do
		download = Factory(:download)
		get :edit, :id => download.id
		assert_redirected_to login_path	
		assert_not_nil flash[:error]
	end

	test "should NOT get edit download without owner login" do
		download = Factory(:download)
		login_as active_user
		get :edit, :id => download.id
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should get edit download with owner login" do
		download = Factory(:download)
		login_as download.user
		get :edit, :id => download.id
		assert_response :success
		assert_template 'edit'
	end

	test "should get edit download with admin login" do
		download = Factory(:download)
		login_as admin_user
		get :edit, :id => download.id
		assert_response :success
		assert_template 'edit'
	end


	test "should NOT update download without login" do
		download = Factory(:download)
		put :update, :id => download.id, :download => {}
		assert_redirected_to login_path	
		assert_not_nil flash[:error]
	end

	test "should NOT update download without owner login" do
		download = Factory(:download)
		login_as active_user
		put :update, :id => download.id, :download => {}
		assert_redirected_to root_path
		assert_not_nil flash[:error]
	end

	test "should fail download update when update_attributes fails" do
		Download.any_instance.stubs(:update_attributes!).raises(ActiveRecord::RecordInvalid.new(Download.new))
		download = Factory(:download)
		login_as download.user
		put :update, :id => download.id, :download => {}
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should get update download with owner login" do
		download = Factory(:download)
		login_as download.user
		put :update, :id => download.id, :download => {}
		assert_response :redirect
	end

	test "should get update download with admin login" do
		download = Factory(:download)
		login_as admin_user
		put :update, :id => download.id, :download => {}
		assert_response :redirect
	end



end

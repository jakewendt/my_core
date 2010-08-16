require File.dirname(__FILE__) + '/../test_helper'

class PhotosControllerTest < ActionController::TestCase

	add_commentability_tests

	test "should NOT get index without login and with invalid user_id" do
		photo = Factory(:photo)
		get :index, :user_id => 0
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get index without login and without user_id" do
		photo = Factory(:photo)
		get :index
		assert_redirected_to login_path
	end

	test "should get index without login and with valid user_id" do
		user = active_user
		photo = Factory(:photo, :user => user)
		get :index, :user_id => user
		assert_not_nil assigns(:photos)
		assert assigns(:photos).include?(photo)
		assert_response :success
		assert_template 'index'
	end

	test "should get index with login and without user_id" do
		user = active_user
		login_as user
		photo = Factory(:photo, :user => user)
		get :index
		assert_not_nil assigns(:photos)
		assert assigns(:photos).include?(photo)
		assert_response :success
		assert_template 'index'
	end

	test "should get index with login and with valid user_id" do
		login_as active_user
		photo = Factory(:photo)
		get :index, :user_id => photo.user
		assert_not_nil assigns(:photos)
		assert assigns(:photos).include?(photo)
		assert_response :success
		assert_template 'index'
	end


	test "should NOT get new without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get new with login" do
		login_as active_user
		get :new
		assert_not_nil assigns(:photo)
		assert_response :success
		assert_template 'new'
	end

	test "should NOT create photo without login" do
		assert_no_difference('Photo.count') do
			post :create, :photo => Factory.attributes_for(:photo)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create photo when save fails" do
		Photo.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(Photo.new))
		user = active_user
		login_as user
		assert_no_difference('Photo.count') do
			post :create, :photo => Factory.attributes_for(:photo)
		end
		assert_equal assigns(:photo).user, user
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should create photo with login" do
		user = active_user
		login_as user
		assert_difference('Photo.count',1) do
			post :create, :photo => Factory.attributes_for(:photo)
		end
		assert_equal assigns(:photo).user, user
		assert_redirected_to assigns(:photo)
	end

	test "should NOT get edit without login" do
		photo = Factory(:photo)
		get :edit, :id => photo
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		photo = Factory(:photo)
		login_as active_user
		get :edit, :id => photo
		assert_not_nil flash[:error]
		assert_equal assigns(:photo), photo
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		photo = Factory(:photo)
		login_as photo.user
		get :edit, :id => photo
		assert_equal assigns(:photo), photo
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without login" do
		photo = Factory(:photo)
		put :update, :id => photo, :photo => Factory.attributes_for(:photo)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update without owner login" do
		photo = Factory(:photo)
		login_as active_user
		put :update, :id => photo, :photo => Factory.attributes_for(:photo)
		assert_not_nil flash[:error]
		assert_equal assigns(:photo), photo
		assert_redirected_to root_path
	end

	test "should NOT update when update_attributes fails" do
		Photo.any_instance.stubs(:update_attributes!).raises(ActiveRecord::RecordInvalid.new(Photo.new))
		photo = Factory(:photo)
		login_as photo.user
		put :update, :id => photo, :photo => Factory.attributes_for(:photo)
		assert_equal assigns(:photo), photo
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update with owner login" do
		photo = Factory(:photo)
		login_as photo.user
		put :update, :id => photo, :photo => Factory.attributes_for(:photo)
		assert_equal assigns(:photo), photo
		assert_redirected_to assigns(:photo)
	end

	test "should get show without login" do
		photo = Factory(:photo)
		get :show, :id => photo
		assert_equal assigns(:photo), photo
		assert_response :success
		assert_template 'show'
	end

	test "should NOT destroy photo without login" do
		photo = Factory(:photo)
		assert_no_difference('Photo.count') do
			delete :destroy, :id => photo
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy photo without owner login" do
		photo = Factory(:photo)
		login_as active_user
		assert_no_difference('Photo.count') do
			delete :destroy, :id => photo
		end
		assert_equal assigns(:photo), photo
		assert_redirected_to root_path
	end

	test "should destroy photo with owner login" do
		photo = Factory(:photo)
		login_as photo.user
		assert_difference('Photo.count',-1) do
			delete :destroy, :id => photo
		end
		assert_equal assigns(:photo), photo
		assert_redirected_to photos_url
	end

	test "should destroy photo RJS with owner login" do
		photo = Factory(:photo)
		login_as photo.user
		wants :js
		assert_difference('Photo.count',-1) do
			delete :destroy, :id => photo
		end
		assert_equal assigns(:photo), photo
		assert_select_rjs :remove, "#photo_#{assigns(:photo).id}"
		assert_select_rjs :replace_html, "#photos_count"
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class ForSaleControllerTest < ActionController::TestCase

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login with no assets for_sale" do
		asset = Factory(:asset, :for_sale => false )
		login_as active_user
		get :index
		assert_response :success
		assert_not_nil assigns(:assets)
		assert_equal 0, assigns(:assets).length
	end

	test "should get index with login with assets for_sale" do
		asset = Factory(:asset, :for_sale => true )
		login_as active_user
		get :index
		assert_response :success
		assert_not_nil assigns(:assets)
		assert_equal 1, assigns(:assets).length
	end

	test "should NOT show asset not for sale" do
		asset = Factory(:asset, :for_sale => false )
		login_as active_user
		get :show, :id => asset.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT show asset for sale without login" do
		asset = Factory(:asset, :for_sale => true )
		get :show, :id => asset.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should show asset for sale with login" do
		asset = Factory(:asset, :for_sale => true )
		login_as active_user
		get :show, :id => asset.id
		assert_response :success
		assert_template 'show'
		assert_equal asset, assigns(:asset)
	end

end

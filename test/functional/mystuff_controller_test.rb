require File.dirname(__FILE__) + '/../test_helper'

class MystuffControllerTest < ActionController::TestCase

	test "should NOT not have new route" do
		assert_raise(ActionController::RoutingError){ get :new }
	end

	test "should NOT not have create route" do
		assert_raise(ActionController::RoutingError){ post :create }
	end

	test "should NOT not have edit route" do
		assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
	end

	test "should NOT not have update route" do
		assert_raise(ActionController::RoutingError){ put :update, :id => 1 }
	end

	test "should NOT not have destroy route" do
		assert_raise(ActionController::RoutingError){ delete :destroy, :id => 1 }
	end

	test "should NOT not have show route" do
		assert_raise(ActionController::RoutingError){ get :show, :id => 1 }
	end

	test "should NOT show users stuff with login" do
		login_as nil
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should show users stuff with login" do
		login_as active_user
		get :index
		assert_response :success
		assert_equal assigns(:user).id, @request.session[:user_id]
		assert_select "title", "My Stuff"
	end

	test "should show users stuff txt with login" do
		login_as active_user
		wants :txt
		get :index
		assert_response :success
		assert_equal assigns(:user).id, @request.session[:user_id]
	end

	test "should show users stuff pdf with login" do
		login_as active_user
		wants :pdf
		get :index
		assert_response :success
		assert_equal assigns(:user).id, @request.session[:user_id]
		assert @response.body.include?("Creator (Prawn)")
	end

end

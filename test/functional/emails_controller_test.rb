require File.dirname(__FILE__) + '/../test_helper'

class EmailsControllerTest < ActionController::TestCase

	def setup
		admin_user(:login => 'admin')	#	need the admin user as it is the default receiver (for now)
	end

	test "should NOT not have edit route" do
		assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
	end

	test "should NOT not have update route" do
		assert_raise(ActionController::RoutingError){ put :update, :id => 1, :email => {} }
	end

	test "should NOT not have show route" do
		assert_raise(ActionController::RoutingError){ get :show, :id => 1 }
	end

	test "should NOT not have index route" do
		assert_raise(ActionController::RoutingError){ get :index }
	end

	test "should NOT not have destroy route" do
		assert_raise(ActionController::RoutingError){ delete :destroy, :id => 1 }
	end

	test "should get new with login" do
		login_as active_user
		get :new
		assert_template 'new'
		assert_response :success
	end

	test "should NOT get new without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should create email with login" do
		login_as active_user
		assert_difference('Email.count') do
			post :create, :email => Factory.attributes_for(:email)
		end
		assert_equal assigns(:email).sender_id, @request.session[:user_id]
		assert_redirected_to root_path
	end

	test "should NOT create invalid email" do
		login_as active_user
		assert_no_difference('Email.count') do
			post :create, :email => Factory.attributes_for(:email).merge(:subject => "")
		end
		assert_equal assigns(:email).sender_id, @request.session[:user_id]
		assert_not_nil flash[:error]
		assert_template 'new'
		assert_response :success
	end

	test "should NOT create email without login" do
		assert_no_difference('Email.count') do
			post :create, :email => Factory.attributes_for(:email)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

end

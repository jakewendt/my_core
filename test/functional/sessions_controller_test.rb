require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

	def setup
		@user = active_user
	end

	test "should NOT have show route" do
		assert_raise(ActionController::RoutingError){
			get :show, :id => 1
		}
	end

	test "should NOT have edit route" do
		assert_raise(ActionController::RoutingError){
			get :edit, :id => 1
		}
	end

	test "should NOT have index route" do
		assert_raise(ActionController::RoutingError){
			get :index
		}
	end

	test "should NOT have update route" do
		assert_raise(ActionController::RoutingError){
			put :update, :id => 1, :session => {}
		}
	end

	test "should login and redirect" do
		u = Factory.attributes_for(:user)
		post :create, :login => @user.login, :password => u[:password]
		assert session[:user_id]
		assert_response :redirect
	end

	test "should login and redirect to return_to" do
		session[:return_to] = "http://cnn.com"
		u = Factory.attributes_for(:user)
		post :create, :login => @user.login, :password => u[:password]
		assert session[:user_id]
		assert_redirected_to "http://cnn.com"
	end

	test "should fail login and not redirect with incorrect password" do
		post :create, :login => @user.login, :password => 'bad password'
		assert_nil session[:user_id]
		assert_not_nil flash[:error]
		assert flash[:error].include?("incorrect")
		assert_response :success
	end

	test "should fail login and not redirect for inactive user" do
		u = Factory.attributes_for(:user)
		user = Factory(:user)
		post :create, :login => user.login, :password => u[:password]
		assert_nil session[:user_id]
		assert_not_nil flash[:error]
		assert flash[:error].include?("not active")
		assert_response :success
	end

	test "should fail login and not redirect for disabled user" do
		u = Factory.attributes_for(:user)
		@user.update_attribute(:enabled, false)
		post :create, :login => @user.login, :password => u[:password]
		assert_nil session[:user_id]
		assert_not_nil flash[:error]
		assert flash[:error].include?("disabled")
		assert_response :success
	end

	test "should logout" do
		login_as @user
		get :destroy
		assert_nil session[:user_id]
		assert_response :redirect
	end

	test "should remember me" do
		u = Factory.attributes_for(:user)
		post :create, :login => @user.login, :password => u[:password], :remember_me => "1"
		assert_not_nil @response.cookies["auth_token"]
	end

	test "should not remember me" do
		u = Factory.attributes_for(:user)
		post :create, :login => @user, :password => u[:password], :remember_me => "0"
		assert_nil @response.cookies["auth_token"]
	end
	
	test "should delete token on logout" do
		login_as @user
		get :destroy
#		assert_equal @response.cookies["auth_token"], []
#	Rails 2.3.2 patch
		assert_nil @response.cookies["auth_token"]
	end

	test "should login with cookie" do
		@user.remember_me
		@request.cookies["auth_token"] = cookie_for(@user)
		get :new
		assert @controller.send(:logged_in?)
	end

	test "should fail expired cookie login" do
		@user.remember_me
		@user.update_attribute :remember_token_expires_at, 5.minutes.ago
		@request.cookies["auth_token"] = cookie_for(@user)
		get :new
		assert !@controller.send(:logged_in?)
	end

	test "should fail cookie login" do
		@user.remember_me
		@request.cookies["auth_token"] = auth_token('invalid_auth_token')
		get :new
		assert !@controller.send(:logged_in?)
	end

protected

	def auth_token(token)
		CGI::Cookie.new('name' => 'auth_token', 'value' => token)
	end

	def cookie_for(user)
		auth_token user.remember_token
	end

end

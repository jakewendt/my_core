require File.dirname(__FILE__) + '/../test_helper'

class PasswordsControllerTest < ActionController::TestCase

	test "should NOT not have index route" do
		assert_raise(ActionController::RoutingError){
			get :index
		}
	end

	test "should NOT not have show route" do
		assert_raise(ActionController::RoutingError){
			get :show, :id => 1
		}
	end

	test "should NOT not have destroy route" do
		assert_raise(ActionController::RoutingError){
			delete :destroy, :id => 1
		}
	end

# new (forgot_password)

	test "should NOT prompt for email address with login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should prompt for email address without login" do
		get :new
		assert_response :success
		assert_template 'new'
	end

# create

	test "should NOT create link with incorrect email" do
		post :create, :email => "fake@email.com"
		assert_response :success
		assert_template 'new'
	end

	test "should create link with correct email" do
		post :create, :email => active_user.email
		assert_redirected_to login_path
	end

	test "should NOT create link without activated user" do
		post :create, :email => Factory(:user).email
		assert_response :success
		assert_template 'new'
	end

# edit (reset_password)

	test "should NOT edit without id" do
		get :edit
		assert_response :success
		assert_template 'new'
	end

	test "should prompt for new password with correct id" do
		u = active_user
		u.forgot_password
		u.save
		get :edit, :id => u.password_reset_code
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT prompt for new password with incorrect id" do
		get :edit, :id => "fakeid"
		assert_redirected_to new_user_path
	end

# update

	test "should NOT update without id" do
		put :update, :id => ""
		assert_response :success
		assert_template 'new'
	end

	test "should NOT update with incorrect id and no password" do
		put :update, :id => "fakeid"
		assert_response :success
		assert_not_nil flash[:error]	#	"Password field cannot be blank."
		assert_equal flash[:error], "Password field cannot be blank."
		assert_template 'edit'
	end

	test "should NOT update with correct id and no password" do
		u = active_user
		u.forgot_password
		u.save
		put :update, :id => u.password_reset_code
		assert_response :success
		assert_not_nil flash[:error]	#	"Password field cannot be blank."
		assert_equal flash[:error], "Password field cannot be blank."
		assert_template 'edit'
	end

	test "should NOT update with incorrect id and blank password" do
		put :update, :id => "fakeid", :password => "", :password_confirmation => ""
		assert_response :success
		assert_not_nil flash[:error]	#	"Password field cannot be blank."
		assert_equal flash[:error], "Password field cannot be blank."
		assert_template 'edit'
	end

	test "should NOT update with incorrect id and valid password" do
		put :update, :id => "fakeid", :password => "new_password", :password_confirmation => "new_password"
		assert_redirected_to new_user_path
		assert_not_nil flash[:error]	#	"Password field cannot be blank."
		assert flash[:error].include?("invalid password reset code")
	end

	test "should NOT update with correct id and blank password" do
		u = active_user
		u.forgot_password
		u.save
		put :update, :id => u.password_reset_code, :password => "", :password_confirmation => ""
		assert_response :success
		assert_not_nil flash[:error]	#	"Password field cannot be blank."
		assert_equal flash[:error], "Password field cannot be blank."
		assert_template 'edit'
	end

	test "should update with correct id and password" do
		u = active_user
		u.forgot_password
		u.save
		put :update, :id => u.password_reset_code,
			:password => "new_password", 
			:password_confirmation => "new_password"
		assert_redirected_to login_path
	end

	test "should NOT update with correct id and mismatched passwords" do
		u = active_user
		u.forgot_password
		u.save
		put :update, :id => u.password_reset_code,
			:password => "new_password", 
			:password_confirmation => "different_password"
		assert_response :success
		assert_not_nil flash[:error]	#	"Password mismatch."
		assert_equal flash[:error], "Password mismatch."
		assert_template 'edit'
	end

end

require File.dirname(__FILE__) + '/../test_helper'

#
#		The accounts_controller is used to activate the user and edit the password
#
class AccountsControllerTest < ActionController::TestCase

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){ get :new, :user_id => 1 }
	end

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){ post :create, :user_id => 1 }
	end

	test "should NOT have index route" do
		assert_raise(ActionController::RoutingError){ get :index, :user_id => 1 }
	end

	test "should NOT have destroy route" do
		assert_raise(ActionController::RoutingError){ delete :destroy, :user_id => 1, :id => 1 }
	end

# edit

	test "should NOT edit without login" do
		login_as nil
		get :edit
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should edit without admin login" do
		login_as active_user
		get :edit
		assert_response :success
		assert_template 'edit'
	end

	test "should edit with admin login" do
		login_as admin_user
		get :edit
		assert_response :success
		assert_template 'edit'
	end

# update (change_password)

	test "should update with login" do
		user = active_user
		login_as user
		put :update,
			:user_id => user,
			:old_password => Factory.attributes_for(:user)[:password],
			:password => 'new_password',
			:password_confirmation => 'new_password'
		assert_not_nil flash[:notice]
		assert_nil		 flash[:error]
		assert_redirected_to user_path( user )
	end

	test "should NOT update with user save failure" do
		User.any_instance.stubs(:save).returns(false)
		user = active_user
		login_as user
		put :update,
			:user_id => user,
			:old_password => Factory.attributes_for(:user)[:password],
			:password => 'new_password',
			:password_confirmation => 'new_password'
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without login" do
		login_as nil
		put :update,
			:user_id => active_user,
			:old_password => Factory.attributes_for(:user)[:password],
			:password => 'new_password',
			:password_confirmation => 'new_password'
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_redirected_to login_path
	end

	test "should NOT update with incorrect old password" do
		user = active_user
		login_as user
		put :update,
			:user_id => user,
			:old_password => 'wrong_password',
			:password => 'new_password',
			:password_confirmation => 'new_password'
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_response :success
		assert_template 'edit'
	end

	test "should NOT update without matching confirmation" do
		user = active_user
		login_as user
		put :update,
			:user_id => user,
			:old_password => Factory.attributes_for(:user)[:password],
			:password => 'new_password',
			:password_confirmation => 'different_password'
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_response :success
		assert_template 'edit'
	end

# show (activate)

	test "should activate new user" do
		new_user = Factory(:user)
		login_as nil
		get :show, :id => new_user.activation_code
		assert_nil		 flash[:error]
		assert_not_nil flash[:notice]
		assert_redirected_to login_path
	end

	test "should NOT activate new user with login" do
		new_user = Factory(:user)
		login_as new_user
		get :show, :id => new_user.activation_code
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_redirected_to root_path
	end

	test "should NOT activate new user without code" do
		login_as nil
		get :show
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_redirected_to new_user_path
	end

	test "should NOT activate new user with invalid code" do
		login_as nil
		get :show, :id => "invalid_activation_code"
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_redirected_to new_user_path
	end

	test "should NOT activate active user" do
		user = active_user
		login_as nil
		get :show, :id => user.activation_code
		assert_not_nil flash[:error]
		assert_nil		 flash[:notice]
		assert_redirected_to login_path
	end

end

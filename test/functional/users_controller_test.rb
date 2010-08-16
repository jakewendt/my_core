require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

	test "should allow signup" do
		assert_difference 'User.count' do
			create_user
			assert_response :redirect
		end
	end

	test "should require login on signup" do
		assert_no_difference 'User.count' do
			create_user(:login => nil)
			assert assigns(:user).errors.on(:login)
			assert_response :success
		end
	end

	test "should require password on signup" do
		assert_no_difference 'User.count' do
			create_user(:password => nil)
			assert assigns(:user).errors.on(:password)
			assert_response :success
		end
	end

	test "should require password confirmation on signup" do
		assert_no_difference 'User.count' do
			create_user(:password_confirmation => nil)
			assert assigns(:user).errors.on(:password_confirmation)
			assert_response :success
		end
	end

	test "should require email on signup" do
		assert_no_difference 'User.count' do
			create_user(:email => nil)
			assert assigns(:user).errors.on(:email)
			assert_response :success
		end
	end
	
	test "should sign up user with activation code" do
		create_user
		assigns(:user).reload
		assert_not_nil assigns(:user).activation_code
	end

# the following 3 tests don't work with activefx's modifications
#
#	test "should activate user" do
#		assert_nil User.authenticate('aaron', 'test')
#		get :activate, :activation_code => users(:aaron).activation_code
#		assert_redirected_to '/'
#		assert_not_nil flash[:notice]
#		assert_equal users(:aaron), User.authenticate('aaron', 'test')
#	end
	
#	test "should not activate user without key" do
#		get :activate
#		assert_nil flash[:notice]
#	rescue ActionController::RoutingError
#		# in the event your routes deny this, we'll just bow out gracefully.
#	end

#	test "should not activate user with blank key" do
#		get :activate, :activation_code => ''
#		assert_nil flash[:notice]
#	rescue ActionController::RoutingError
#		# well played, sir
#	end

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get index without admin login" do
		login_as active_user
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get index with admin login" do
		user = admin_user
		login_as user
		get :index
		assert assigns(:users).include?(user)
		assert_response :success
	end

	test "should NOT get show without login" do
		user = active_user
		get :show, :id => user.to_param
		assert_redirected_to login_path
	end

	test "should get show with user login" do
		user = active_user
		login_as user
		get :show, :id => user.to_param
		assert assigns(:user)
		assert_response :success
	end

	test "should get show with admin login" do
		user = active_user
		login_as admin_user
		get :show, :id => user.to_param
		assert assigns(:user)
		assert_response :success
	end

	test "should NOT get edit without login" do
		user = active_user
		get :edit, :id => user.to_param
		assert_redirected_to login_path
	end

	test "should get edit with user login" do
		user = active_user
		login_as user
		get :edit, :id => user.to_param
		assert assigns(:user)
		assert_response :success
	end

	test "should get edit with admin login" do
		user = active_user
		login_as admin_user
		get :edit, :id => user.to_param
		assert assigns(:user)
		assert_response :success
	end

	test "should get new without login" do
		get :new
		assert_response :success
	end

	test "should NOT get new with login" do
		login_as active_user
		get :new
		assert_redirected_to root_path
	end

	test "should update user with admin login" do
		login_as admin_user
		put :update, :id => active_user, :user => Factory.attributes_for(:user)
		assert_redirected_to assigns(:user)
	end

	test "should NOT update user with invalid user" do
		login_as admin_user
		put :update, :id => active_user, :user => Factory.attributes_for(:user).merge(:login => 'a')
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

	test "should update user with self login" do
		user = active_user
		login_as user
		put :update, :id => user, :user => Factory.attributes_for(:user)
		assert_redirected_to assigns(:user)
	end

	test "should NOT update user without login" do
		user = active_user
		put :update, :id => user, :user => Factory.attributes_for(:user)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT enable user without login" do
		user = active_user
		user.update_attribute(:enabled, false)
		assert !user.enabled
		put :enable, :id => user
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT enable user without admin login" do
		login_as active_user
		user = active_user
		user.update_attribute(:enabled, false)
		assert !user.enabled
		put :enable, :id => user
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT enable user update_attribute fails" do
		login_as admin_user
		user = active_user
		user.update_attribute(:enabled, false)
		User.any_instance.stubs(:update_attribute).returns(false)
		assert !user.enabled
		put :enable, :id => user
		assert !assigns(:user).enabled
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should enable user with admin login" do
		login_as admin_user
		user = active_user
		user.update_attribute(:enabled, false)
		assert !user.enabled
		put :enable, :id => user
		assert assigns(:user).enabled
		assert_not_nil flash[:notice]
		assert_redirected_to users_path
	end


	test "should NOT disable user without login" do
		user = active_user
		user.update_attribute(:enabled, true)
		assert user.enabled
		delete :destroy, :id => user
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT disable user without admin login" do
		login_as active_user
		user = active_user
		user.update_attribute(:enabled, true)
		assert user.enabled
		delete :destroy, :id => user
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT disable user when update_attribute fails" do
		login_as admin_user
		user = active_user
		user.update_attribute(:enabled, true)
		User.any_instance.stubs(:update_attribute).returns(false)
		assert user.enabled
		delete :destroy, :id => user
		assert assigns(:user).enabled
		assert_not_nil flash[:error]
		assert_redirected_to users_path
	end

	test "should disable user with admin login" do
		login_as admin_user
		user = active_user
		user.update_attribute(:enabled, true)
		assert user.enabled
		delete :destroy, :id => user
		assert !assigns(:user).enabled
		assert_not_nil flash[:notice]
		assert_redirected_to users_path
	end


protected

	def create_user(options = {})
		post :create, :user => { 
			:login => 'quire', 
			:email => 'test7@jakewendt.com',
			:password => 'quire', 
			:password_confirmation => 'quire' 
		}.merge(options)
	end
end

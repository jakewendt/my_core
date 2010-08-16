require File.dirname(__FILE__) + '/../test_helper'

class RolesControllerTest < ActionController::TestCase

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){
			get :new, :user_id => 1
		}
	end

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){
			post :create, :user_id => 1, :role => {}
		}
	end

	test "should NOT have edit route" do
		assert_raise(ActionController::RoutingError){
			get :edit, :user_id => 1, :id => 1
		}
	end

	test "should NOT have show route" do
		assert_raise(ActionController::RoutingError){
			get :show, :user_id => 1, :id => 1
		}
	end



	test "should get index with administrator login" do
		login_as admin_user
		get :index, :user_id => active_user.id
		assert_response :success
	end

	test "should NOT get index without login" do
		get :index, :user_id => active_user.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get index without administrator login" do
		user = active_user
		login_as user
		get :index, :user_id => user.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should update role with administrator login" do
		user = active_user
		login_as admin_user
		assert_difference('user.roles.reload.length',1) do
			put :update, :id => admin_role.id, :user_id => user.id
		end
		assert_redirected_to user_roles_path(user)
	end

	test "should NOT update role without administrator login" do
		user = active_user
		login_as user
		assert_no_difference('user.roles.reload.length') do
			put :update, :id => admin_role.id, :user_id => user.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update role without login" do
		user = active_user
		assert_no_difference('user.roles.reload.length') do
			put :update, :id => admin_role.id, :user_id => user.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should destroy role with administrator login" do
		user = admin_user
		login_as admin_user
		assert_difference('user.roles.reload.length',-1) do
			delete :destroy, :id => admin_role.id, :user_id => user.id
		end
		assert_redirected_to user_roles_path(user)
	end

	test "should destroy own role with administrator login" do
		user = admin_user
		login_as user
		assert_difference('user.roles.reload.length',-1) do
			delete :destroy, :id => admin_role.id, :user_id => user.id
		end
		assert_redirected_to user_path(user)
	end

	test "should NOT destroy role without administrator login" do
		user = admin_user
		login_as active_user
		assert_no_difference('user.roles.reload.length') do
			delete :destroy, :id => admin_role.id, :user_id => user.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT destroy role without login" do
		user = admin_user
		assert_no_difference('user.roles.reload.length') do
			delete :destroy, :id => admin_role.id, :user_id => user.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end


#	This eventually could be an added feature
#	but as of right now, the only role in Administrator
#	and I created it by hand.

#	test "should redirect on new with administrator login" do
#		user = active_user
#		login_as admin_user
#		get :new, :user_id => user.id
#		assert_redirected_to root_url
#	end
#
#	test "should redirect on edit with administrator login" do
#		user = active_user
#		login_as admin_user
#		get :edit, :user_id => user.id, :id => admin_role.id
#		assert_redirected_to root_url
#	end
#
#	test "should redirect on create with administrator login" do
#		user = active_user
#		login_as admin_user
#		post :create, :user_id => user.id
#		assert_redirected_to root_url
#	end
#
#	test "should redirect on show with administrator login" do
#		user = active_user
#		login_as admin_user
#		get :show, :user_id => user.id, :id => admin_role.id
#		assert_redirected_to root_url
#	end

end

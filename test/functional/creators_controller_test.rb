require File.dirname(__FILE__) + '/../test_helper'

class CreatorsControllerTest < ActionController::TestCase

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){
			post :create, :creator => Factory.attributes_for(:creator)
		}
	end

	test "should NOT get index without login" do
		creator = Factory(:creator)
		get :index
		assert_nil assigns(:creators)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		creator = Factory(:creator)
		login_as creator.user
		get :index
		assert_response :success
		assert_not_nil assigns(:creators)
	end

	test "should NOT show creator without owner login" do
		creator = Factory(:creator)
		login_as active_user
		get :show, :id => creator.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show creator with owner login" do
		creator = Factory(:creator)
		login_as creator.user
		get :show, :id => creator.to_param
		assert_not_nil assigns(:creator)
#		assert_response :success
		assert_redirected_to assets_path(:creator => creator.name)
	end

	test "should NOT get edit without owner login" do
		creator = Factory(:creator)
		login_as active_user
		get :edit, :id => creator.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		creator = Factory(:creator)
		login_as creator.user
		get :edit, :id => creator.to_param
		assert_not_nil assigns(:creator)
		assert_response :success
	end

	test "should NOT update creator without owner login" do
		creator = Factory(:creator)
		login_as active_user
		put :update, :id => creator.to_param, :creator => { }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update creator with invalid creator" do
		creator = Factory(:creator)
#		Creator.any_instance.stubs(:update_attributes!).raises(ActiveRecord::RecordInvalid.new(Creator.new))
		login_as creator.user
		put :update, :id => creator.to_param, :creator => { :name => '' }
		assert_not_nil assigns(:creator)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update creator with owner login" do
		creator = Factory(:creator)
		login_as creator.user
		put :update, :id => creator.to_param, :creator => { }
		assert_not_nil assigns(:creator)
		assert_redirected_to creator_path(assigns(:creator))
	end

	test "should NOT destroy creator without owner login" do
		creator = Factory(:creator)
		login_as active_user
		assert_no_difference('Creator.count') do
			delete :destroy, :id => creator.to_param
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy creator with owner login" do
		creator = Factory(:creator)
		login_as creator.user
		assert_difference('Creator.count', -1) do
			delete :destroy, :id => creator.to_param
		end
		assert_not_nil assigns(:creator)
		assert_redirected_to creators_path
	end

end

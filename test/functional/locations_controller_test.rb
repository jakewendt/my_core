require File.dirname(__FILE__) + '/../test_helper'

class LocationsControllerTest < ActionController::TestCase

	test "should NOT not have new route" do
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT not have create route" do
		assert_raise(ActionController::RoutingError){
			post :create, :location => Factory.attributes_for(:location)
		}
	end

	test "should NOT get index without login" do
		location = Factory(:location)
		get :index
		assert_nil assigns(:locations)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		location = Factory(:location)
		login_as location.user
		get :index
		assert_response :success
		assert_not_nil assigns(:locations)
	end

	test "should NOT show location without owner login" do
		location = Factory(:location)
		login_as active_user
		get :show, :id => location.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show location with owner login" do
		location = Factory(:location)
		login_as location.user
		get :show, :id => location.to_param
		assert_not_nil assigns(:location)
#		assert_response :success
		assert_redirected_to assets_path(:location => location.name)
	end

	test "should NOT get edit without owner login" do
		location = Factory(:location)
		login_as active_user
		get :edit, :id => location.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		location = Factory(:location)
		login_as location.user
		get :edit, :id => location.to_param
		assert_not_nil assigns(:location)
		assert_response :success
	end

	test "should NOT update location without owner login" do
		location = Factory(:location)
		login_as active_user
		put :update, :id => location.to_param, :location => { }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update location with invalid location" do
		location = Factory(:location)
#		Location.any_instance.stubs(:update_attributes!).raises(ActiveRecord::RecordInvalid.new(Location.new))
		login_as location.user
		put :update, :id => location.to_param, :location => { :name => '' }
		assert_not_nil assigns(:location)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update location with owner login" do
		location = Factory(:location)
		login_as location.user
		put :update, :id => location.to_param, :location => { }
		assert_not_nil assigns(:location)
		assert_redirected_to location_path(assigns(:location))
	end

	test "should NOT destroy location without owner login" do
		location = Factory(:location)
		login_as active_user
		assert_no_difference('Location.count') do
			delete :destroy, :id => location.to_param
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy location with owner login" do
		location = Factory(:location)
		login_as location.user
		assert_difference('Location.count', -1) do
			delete :destroy, :id => location.to_param
		end
		assert_not_nil assigns(:location)
		assert_redirected_to locations_path
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){
			get :new
		}
	end

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){
			post :create, :category => Factory.attributes_for(:category)
		}
	end


	test "should NOT get index without login" do
		category = Factory(:category)
		get :index
		assert_nil assigns(:categories)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		category = Factory(:category)
		login_as category.user
		get :index
		assert_response :success
		assert_not_nil assigns(:categories)
	end

	test "should NOT show category without owner login" do
		category = Factory(:category)
		login_as active_user
		get :show, :id => category.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show category with owner login" do
		category = Factory(:category)
		login_as category.user
		get :show, :id => category.to_param
		assert_not_nil assigns(:category)
#		assert_response :success
		assert_redirected_to assets_path(:category => category.name)
	end

	test "should NOT get edit without owner login" do
		category = Factory(:category)
		login_as active_user
		get :edit, :id => category.to_param
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		category = Factory(:category)
		login_as category.user
		get :edit, :id => category.to_param
		assert_not_nil assigns(:category)
		assert_response :success
	end

	test "should NOT update category without owner login" do
		category = Factory(:category)
		login_as active_user
		put :update, :id => category.to_param, :category => { }
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update category with invalid category" do
		category = Factory(:category)
#		Category.any_instance.stubs(:update_attributes!).raises(ActiveRecord::RecordInvalid.new(Category.new))
		login_as category.user
		put :update, :id => category.to_param, :category => { :name => '' }
		assert_not_nil assigns(:category)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update category with owner login" do
		category = Factory(:category)
		login_as category.user
		put :update, :id => category.to_param, :category => { }
		assert_not_nil assigns(:category)
		assert_redirected_to category_path(assigns(:category))
	end

	test "should NOT destroy category without owner login" do
		category = Factory(:category)
		login_as active_user
		assert_no_difference('Category.count') do
			delete :destroy, :id => category.to_param
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy category with owner login" do
		category = Factory(:category)
		login_as category.user
		assert_difference('Category.count', -1) do
			delete :destroy, :id => category.to_param
		end
		assert_not_nil assigns(:category)
		assert_redirected_to categories_path
	end

end

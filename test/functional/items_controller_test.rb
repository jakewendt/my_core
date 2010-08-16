require File.dirname(__FILE__) + '/../test_helper'

class ItemsControllerTest < ActionController::TestCase
	add_orderability_tests :list, :items
	add_core_tests :item, :only => [ :confirm_destroy ]

	test "should NOT not have index route" do
		assert_raise(ActionController::RoutingError){ get :index, :list_id => 1 }
	end

	test "should NOT not have new route" do
		assert_raise(ActionController::RoutingError){ get :new, :list_id => 1 }
	end

	test "should NOT not have edit route" do
		assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
	end

	test "should NOT not have show route" do
		assert_raise(ActionController::RoutingError){ get :show, :id => 1 }
	end

	test "should NOT not have destroy route" do
		assert_raise(ActionController::RoutingError){ delete :destroy, :id => 1 }
	end


	test "should NOT create item without login" do
		item = Factory(:public_item)
		assert_no_difference('Item.count') do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_redirected_to login_path
	end

	test "should NOT create item without owner login" do
		item = Factory(:public_item)
		login_as active_user
		assert_no_difference('Item.count') do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_redirected_to root_path
	end

	test "should create item without content via ajax" do
		item = Factory(:public_item)
		login_as item.user
		wants :js
		assert_difference('Item.count',1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item).merge(:content => '')
		end
		assert_response :success
		assert_select_rjs :insert_bottom, "#items"
		assert_select_rjs :highlight, "#item_#{assigns(:item).id}"
		assert_select_rjs :reset, "#new_item"
	end

	test "should create item without content via html" do
		item = Factory(:public_item)
		login_as item.user
		assert_difference('Item.count',1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item).merge(:content => '')
		end
		assert_not_nil flash[:notice]
		assert_redirected_to assigns(:list)
	end

	test "should NOT create item with item save failure via ajax" do
		Item.any_instance.stubs(:save).returns(false)
		item = Factory(:public_item)
		login_as item.user
		wants :js
		assert_no_difference('Item.count') do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_response :success
		assert @response.body.blank?
	end

	test "should NOT create item with item save failure via html" do
		Item.any_instance.stubs(:save).returns(false)
		item = Factory(:public_item)
		login_as item.user
		assert_no_difference('Item.count') do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_not_nil flash[:error]
		assert_redirected_to assigns(:list)
	end

	test "should create item with owner login via ajax" do
		item = Factory(:public_item)
		login_as item.user
		wants :js
		assert_difference('Item.count', 1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_response :success
		assert_select_rjs :insert_bottom, "#items"
		assert_select_rjs :highlight, "#item_#{assigns(:item).id}"
		assert_select_rjs :reset, "#new_item"
	end

	test "should create item with owner login via html" do
		item = Factory(:public_item)
		login_as item.user
		assert_difference('Item.count', 1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_redirected_to assigns(:list)
		assert_not_nil flash[:notice]
	end

	test "should create item with admin login via ajax" do
		item = Factory(:public_item)
		login_as admin_user
		wants :js
		assert_difference('Item.count', 1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_response :success
		assert_select_rjs :insert_bottom, "#items"
		assert_select_rjs :highlight, "#item_#{assigns(:item).id}"
		assert_select_rjs :reset, "#new_item"
	end

	test "should create item with admin login via html" do
		item = Factory(:public_item)
		login_as admin_user
		assert_difference('Item.count', 1) do
			post :create, :list_id => item.list.id, :item => Factory.attributes_for(:item)
		end
		assert_redirected_to assigns(:list)
		assert_not_nil flash[:notice]
	end

	#
	#		Need update for complete
	#
	test "should NOT update item without login" do
		item = Factory(:public_item)
		put :update, :id => item.id, :item => Factory.attributes_for(:completed_item)
		assert_redirected_to login_path
	end

	test "should NOT update item without owner login" do
		item = Factory(:public_item)
		login_as active_user
		put :update, :id => item.id, :item => Factory.attributes_for(:completed_item)
		assert_equal assigns(:item).completed, false
		assert_redirected_to root_path
	end

	test "should NOT update item with update_attributes failure" do
		Item.any_instance.stubs(:update_attributes!).raises(StandardError)
		item = Factory(:public_item)
		login_as item.user
		put :update, :id => item.id, :item => Factory.attributes_for(:completed_item)
		assert_equal assigns(:item).completed, false
		assert_response :success
		assert_not_nil flash[:error]
		assert @response.body.blank?
	end

	test "should update item with owner login" do
		item = Factory(:public_item)
		login_as item.user
		put :update, :id => item.id, :item => Factory.attributes_for(:completed_item)
		assert_equal assigns(:item).completed, true
		assert_response :success
		assert_select_rjs :append_to, "#item_#{assigns(:item).id}", "#completed_items"
	end

	test "should update item with admin login" do
		item = Factory(:public_item)
		login_as admin_user
		put :update, :id => item.id, :item => Factory.attributes_for(:completed_item)
		assert_equal assigns(:item).completed, true
		assert_response :success
		assert_select_rjs :append_to, "#item_#{assigns(:item).id}", "#completed_items"
	end


#	test "should NOT destroy item without login" do
#		item = Factory(:public_item)
#		assert_no_difference('Item.count') do
#			delete :destroy, :id => item.id
#		end
#		assert_redirected_to login_path
#	end
#
#	test "should NOT destroy item without owner login" do
#		item = Factory(:public_item)
#		login_as active_user
#		assert_no_difference('Item.count') do
#			delete :destroy, :id => item.id
#		end
#		assert_redirected_to root_path
#	end
#
#	test "should destroy item with owner login via ajax" do
#		item = Factory(:public_item)
#		login_as item.user
#		wants :js
#		assert_difference('Item.count', -1) do
#			delete :destroy, :id => item.id
#		end
#		assert_response :success
#		assert_select_rjs :remove, "#item_#{assigns(:item).id}"
#	end
#
#	test "should destroy item with admin login via ajax" do
#		item = Factory(:public_item)
#		login_as admin_user
#		wants :js
#		assert_difference('Item.count', -1) do
#			delete :destroy, :id => item.id
#		end
#		assert_response :success
#		assert_select_rjs :remove, "#item_#{assigns(:item).id}"
#	end
#
#	test "should destroy item with owner login via html" do
#		item = Factory(:public_item)
#		login_as item.user
#		assert_difference('Item.count', -1) do
#			delete :destroy, :id => item.id
#		end
#		assert_redirected_to edit_list_path(assigns(:item).list)
#	end
#
#	test "should destroy item with admin login via html" do
#		item = Factory(:public_item)
#		login_as admin_user
#		assert_difference('Item.count', -1) do
#			delete :destroy, :id => item.id
#		end
#		assert_redirected_to edit_list_path(assigns(:item).list)
#	end

end

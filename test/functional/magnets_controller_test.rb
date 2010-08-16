require File.dirname(__FILE__) + '/../test_helper'

class MagnetsControllerTest < ActionController::TestCase
	add_core_tests :magnet, :only => [ :confirm_destroy ]

	test "should NOT not have new route" do
		assert_raise(ActionController::RoutingError){ get :new, :board_id => 1 }
	end

	test "should NOT not have edit route" do
		assert_raise(ActionController::RoutingError){ get :edit, :id => 1 }
	end

	test "should NOT not have index route" do
		assert_raise(ActionController::RoutingError){ get :index, :board_id => 1 }
	end

	test "should NOT not have show route" do
		assert_raise(ActionController::RoutingError){ get :show, :id => 1 }
	end

	test "should NOT not have destroy route" do
		assert_raise(ActionController::RoutingError){ delete :destroy, :id => 1 }
	end


	test "should NOT create magnet without login" do
		magnet = Factory(:magnet)
		assert_no_difference('Magnet.count') do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_redirected_to login_path
	end

	test "should NOT create magnet without owner login" do
		magnet = Factory(:magnet)
		login_as active_user
		assert_no_difference('Magnet.count') do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_redirected_to root_path
	end

	test "should NOT create magnet when save fails via html" do
		Magnet.any_instance.stubs(:save).returns(false)
		magnet = Factory(:magnet)
		login_as magnet.user
		assert_no_difference('Magnet.count') do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_redirected_to edit_board_path(assigns(:magnet).board)
		assert_not_nil flash[:error]
	end

	test "should NOT create magnet when save fails via ajax" do
		Magnet.any_instance.stubs(:save).returns(false)
		magnet = Factory(:magnet)
		wants :js
		login_as magnet.user
		assert_no_difference('Magnet.count') do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_response :success
		assert @response.body.blank?
	end

	test "should create magnet with owner login via html" do
		magnet = Factory(:magnet)
		login_as magnet.user
		assert_difference('Magnet.count', 1) do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_not_nil flash[:notice]
		assert_redirected_to edit_board_path(assigns(:magnet).board)
	end

	test "should create magnet with admin login via html" do
		magnet = Factory(:magnet)
		login_as admin_user
		assert_difference('Magnet.count', 1) do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_not_nil flash[:notice]
		assert_redirected_to edit_board_path(assigns(:magnet).board)
	end

	test "should create magnet with owner login via ajax" do
		magnet = Factory(:magnet)
		login_as magnet.user
		wants :js
		assert_difference('Magnet.count', 1) do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_response :success
		assert_select_rjs :insert_bottom, "#magnets"
	end

	test "should create magnet with admin login via ajax" do
		magnet = Factory(:magnet)
		login_as admin_user
		wants :js
		assert_difference('Magnet.count', 1) do
			post :create, :board_id => magnet.board.id, :magnet => {}
		end
		assert_response :success
		assert_select_rjs :insert_bottom, "#magnets"
	end

	#
	#		Need update for position changes
	#
	test "should NOT update magnet without top" do
		magnet = Factory(:magnet)
		put :update, :id => magnet.id, :magnet => { :left => 100 }
		assert_response :success
		assert_not_nil flash[:error]
		assert @response.body.blank?
	end

	test "should update magnet without login" do
		magnet = Factory(:magnet)
		put :update, :id => magnet.id, :magnet => { :left => 100, :top => 200 }
		assert_response :success
#	doesn't replace or insert html so assert_select_rjs fails
#		assert_select_rjs
#	maybe add some bounce or pulsing effect to a dropped magnet?
	end


#	test "should NOT destroy magnet without login" do
#		magnet = Factory(:magnet)
#		assert_no_difference('Magnet.count') do
#			delete :destroy, :id => magnet.id
#		end
#		assert_not_nil flash[:error]
#		assert_redirected_to login_path
#	end
#
#	test "should NOT destroy magnet without owner login" do
#		magnet = Factory(:magnet)
#		login_as active_user
#		assert_no_difference('Magnet.count') do
#			delete :destroy, :id => magnet.id
#		end
#		assert_not_nil flash[:error]
#		assert_redirected_to root_path
#	end
#
#	test "should destroy magnet with owner login via html" do
#		magnet = Factory(:magnet)
#		login_as magnet.user
#		assert_difference('Magnet.count', -1) do
#			delete :destroy, :id => magnet.id
#		end
#		assert_redirected_to edit_board_path(assigns(:magnet).board)
#	end
#
#	test "should destroy magnet with owner login via ajax" do
#		magnet = Factory(:magnet)
#		login_as magnet.user
#		wants :js
#		assert_difference('Magnet.count', -1) do
#			delete :destroy, :id => magnet.id
#		end
#		assert_response :success
#		assert_select_rjs :remove, "#magnet_#{assigns(:magnet).id}"
#	end
#
#	test "should destroy magnet with admin login via html" do
#		magnet = Factory(:magnet)
#		login_as admin_user
#		assert_difference('Magnet.count', -1) do
#			delete :destroy, :id => magnet.id
#		end
#		assert_redirected_to edit_board_path(assigns(:magnet).board)
#	end
#
#	test "should destroy magnet with admin login via ajax" do
#		magnet = Factory(:magnet)
#		login_as admin_user
#		wants :js
#		assert_difference('Magnet.count', -1) do
#			delete :destroy, :id => magnet.id
#		end
#		assert_response :success
#		assert_select_rjs :remove, "#magnet_#{assigns(:magnet).id}"
#	end

end

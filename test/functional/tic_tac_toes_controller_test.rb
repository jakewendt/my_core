require File.dirname(__FILE__) + '/../test_helper'

class TicTacToesControllerTest < ActionController::TestCase

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		ttt = Factory(:tic_tac_toe)
		login_as ttt.player_1
		get :index
		assert_response :success
		assert_not_nil assigns(:tic_tac_toes)
	end

	test "should NOT get new without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get new with login" do
		login_as active_user
		get :new
		assert_response :success
	end

	test "should NOT create tic_tac_toe without login" do
		player_2 = active_user
		assert_no_difference('TicTacToe.count') do
			post :create, :tic_tac_toe => { :player_2_id => player_2.id  }
		end
		assert_redirected_to login_path
	end

	test "should NOT create tic_tac_toe when save fails" do
		player_1 = active_user
		player_2 = active_user
		login_as player_1
		TicTacToe.any_instance.stubs(:save).returns(false)
		assert_no_difference('TicTacToe.count') do
			post :create, :tic_tac_toe => { :player_2_id => player_2.id  }
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should create tic_tac_toe with login" do
		player_1 = active_user
		player_2 = active_user
		login_as player_1
		assert_difference('TicTacToe.count') do
			post :create, :tic_tac_toe => { :player_2_id => player_2.id  }
		end
		assert_equal player_1.id, assigns(:tic_tac_toe).player_1_id
		assert_equal player_2.id, assigns(:tic_tac_toe).player_2_id
		assert_not_nil assigns(:tic_tac_toe).turn_id
		assert_nil     assigns(:tic_tac_toe).winner_id
		assert_redirected_to tic_tac_toe_path(assigns(:tic_tac_toe))
	end

	test "should NOT show tic_tac_toe without login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		get :show, :id => tic_tac_toe.id
		assert_redirected_to login_path
	end

	test "should NOT show tic_tac_toe without player login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as active_user
		get :show, :id => tic_tac_toe.id
		assert_redirected_to root_path
	end

	test "should show tic_tac_toe with player 1 login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as tic_tac_toe.player_1
		get :show, :id => tic_tac_toe.id
		assert_response :success
	end

	test "should show tic_tac_toe with player 2 login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as tic_tac_toe.player_2
		get :show, :id => tic_tac_toe.id
		assert_response :success
	end

	test "should show tic_tac_toe with admin login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as admin_user
		get :show, :id => tic_tac_toe.id
		assert_response :success
	end

#	test "should show tic_tac_toe with batter login via js" do
#		tic_tac_toe = Factory(:tic_tac_toe)
#		login_as tic_tac_toe.batter
#		wants :js
#		get :show, :id => tic_tac_toe.id
#		assert_response :success
#		assert_select_rjs :replace_html, "#tic_tac_toe_#{tic_tac_toe.id}"
#	end

#	test "should show game over tic_tac_toe with player login via js" do
#		tic_tac_toe = Factory(:tic_tac_toe)
#		tic_tac_toe.update_attribute(:turn_id, nil)
#		login_as tic_tac_toe.player_1
#		wants :js
#		get :show, :id => tic_tac_toe.id
#		assert_response :success
#		assert_select_rjs :replace_html, "#tic_tac_toe_#{tic_tac_toe.id}"
#	end

#	test "should show tic_tac_toe with on deck login via js" do
#		tic_tac_toe = Factory(:tic_tac_toe)
#		login_as tic_tac_toe.on_deck
#		wants :js
#		get :show, :id => tic_tac_toe.id
#		assert_response :success
#		assert @response.body.include?("setTimeout(function(){reload_board();},5000);")
#	end

#	test "should show complete tic_tac_toe with player login via js" do
#		tic_tac_toe = Factory(:tic_tac_toe)
#		login_as tic_tac_toe.batter
#		TicTacToe.any_instance.stubs(:turn_id).returns(nil)
#		wants :js
#		get :show, :id => tic_tac_toe.id
#		assert_response :success
#		assert_select_rjs :replace_html, "#tic_tac_toe_#{tic_tac_toe.id}"
#	end

	test "should update tic_tac_toe with batter login" do
		TicTacToesController.skip_after_filter :validate_page
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as tic_tac_toe.batter
		put :update, :id => tic_tac_toe, :square => 0
	end

#	I do not understand why the batter login causes problems while the admin login does not?
#	Ahh.   This is probably because the admin user gets kicked to a NotPlayersTurn

	test "should update tic_tac_toe with admin login" do
		tic_tac_toe = Factory(:tic_tac_toe)
		login_as admin_user
		put :update, :id => tic_tac_toe, :square => 0
		assert_not_nil flash[:error]
	end

end

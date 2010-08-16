require File.dirname(__FILE__) + '/../test_helper'

class ConnectFoursControllerTest < ActionController::TestCase

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		c4 = Factory(:connect_four)
		login_as c4.player_1
		get :index
		assert_response :success
		assert_not_nil assigns(:connect_fours)
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

	test "should NOT create connect_four without login" do
		player_2 = active_user
		assert_no_difference('ConnectFour.count') do
			post :create, :connect_four => { :player_2_id => player_2.id  }
		end
		assert_redirected_to login_path
	end

	test "should NOT create connect_four when save fails" do
		player_1 = active_user
		player_2 = active_user
		login_as player_1
		ConnectFour.any_instance.stubs(:save).returns(false)
		assert_no_difference('ConnectFour.count') do
			post :create, :connect_four => { :player_2_id => player_2.id  }
		end
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should create connect_four with login" do
		player_1 = active_user
		player_2 = active_user
		login_as player_1
		assert_difference('ConnectFour.count') do
			post :create, :connect_four => { :player_2_id => player_2.id  }
		end
		assert_equal player_1.id, assigns(:connect_four).player_1_id
		assert_equal player_2.id, assigns(:connect_four).player_2_id
		assert_not_nil assigns(:connect_four).turn_id
		assert_nil     assigns(:connect_four).winner_id
		assert_redirected_to connect_four_path(assigns(:connect_four))
	end

	test "should NOT show connect_four without login" do
		connect_four = Factory(:connect_four)
		get :show, :id => connect_four.id
		assert_redirected_to login_path
	end

	test "should NOT show connect_four without player login" do
		connect_four = Factory(:connect_four)
		login_as active_user
		get :show, :id => connect_four.id
		assert_redirected_to root_path
	end

	test "should show connect_four with player 1 login" do
		connect_four = Factory(:connect_four)
		login_as connect_four.player_1
		get :show, :id => connect_four.id
		assert_response :success
	end

	test "should show connect_four with player 2 login" do
		connect_four = Factory(:connect_four)
		login_as connect_four.player_2
		get :show, :id => connect_four.id
		assert_response :success
	end

	test "should show connect_four with admin login" do
		connect_four = Factory(:connect_four)
		login_as admin_user
		get :show, :id => connect_four.id
		assert_response :success
	end

	test "should update connect_four with batter login" do
		ConnectFoursController.skip_after_filter :validate_page
		connect_four = Factory(:connect_four)
		login_as connect_four.batter
		put :update, :id => connect_four, :square => 0
	end

#	I do not understand why the batter login causes problems while the admin login does not?
#	Ahh.   This is probably because the admin user gets kicked to a NotPlayersTurn

	test "should update connect_four with admin login" do
		connect_four = Factory(:connect_four)
		login_as admin_user
		put :update, :id => connect_four, :square => 0
		assert_not_nil flash[:error]
	end

end

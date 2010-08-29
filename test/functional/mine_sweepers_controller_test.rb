require File.dirname(__FILE__) + '/../test_helper'

class MineSweepersControllerTest < ActionController::TestCase

	test "should get new without login" do
		get :new
		assert_response :success
	end

	test "should show without login" do
		get :show
		assert_response :success
	end

end

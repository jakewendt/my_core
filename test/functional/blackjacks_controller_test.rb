require File.dirname(__FILE__) + '/../test_helper'

class BlackjacksControllerTest < ActionController::TestCase

	test "should show without login" do
		get :show
		assert_response :success
	end

end

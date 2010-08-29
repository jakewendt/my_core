require File.dirname(__FILE__) + '/../test_helper'

class YahtzeesControllerTest < ActionController::TestCase

	test "should show without login" do
		get :show
		assert_response :success
	end

end

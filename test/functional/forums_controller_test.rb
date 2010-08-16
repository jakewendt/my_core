require File.dirname(__FILE__) + '/../test_helper'

class ForumsControllerTest < ActionController::TestCase

	test "should get index without login" do
		get :index
		assert_response :success
		assert_not_nil assigns(:forums)
	end


	test "should NOT get new without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get new without admin login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_response :success
	end


	test "should NOT create forum without login" do
		assert_no_difference('Forum.count') do
			post :create, :forum => Factory.attributes_for(:forum)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create forum without admin login" do
		login_as active_user
		assert_no_difference('Forum.count') do
			post :create, :forum => Factory.attributes_for(:forum)
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT create invalid forum without name" do
		login_as admin_user
		assert_no_difference('Forum.count') do
			post :create, :forum => Factory.attributes_for(:forum).merge(:name => '')
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should create forum with admin login" do
		login_as admin_user
		assert_difference('Forum.count',1) do
			post :create, :forum => Factory.attributes_for(:forum)
		end
		assert_redirected_to forums_path
	end


	test "should show forum without login" do
		forum = Factory(:forum)
		get :show, :id => forum.id
		assert_redirected_to forum_topics_path( forum )
	end


	test "should NOT get edit without login" do
		forum = Factory(:forum)
		get :edit, :id => forum.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without admin login" do
		forum = Factory(:forum)
		login_as active_user
		get :edit, :id => forum.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with admin login" do
		forum = Factory(:forum)
		login_as admin_user
		get :edit, :id => forum.id
		assert_response :success
	end


	test "should NOT update forum without login" do
		forum = Factory(:forum)
		put :update, :id => forum.id, :forum => Factory.attributes_for(:forum)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update forum without admin login" do
		forum = Factory(:forum)
		login_as active_user
		put :update, :id => forum.id, :forum => Factory.attributes_for(:forum)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update forum without name" do
		forum = Factory(:forum)
		login_as admin_user
		put :update, :id => forum.id, :forum => Factory.attributes_for(:forum).merge(:name => '')
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should update forum with admin login" do
		forum = Factory(:forum)
		login_as admin_user
		put :update, :id => forum.id, :forum => Factory.attributes_for(:forum)
		assert_redirected_to forum_path(assigns(:forum))
	end


	test "should NOT destroy forum without login" do
		forum = Factory(:forum)
		assert_no_difference('Forum.count') do
			delete :destroy, :id => forum.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy forum without admin login" do
		forum = Factory(:forum)
		login_as active_user
		assert_no_difference('Forum.count') do
			delete :destroy, :id => forum.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy forum with admin login" do
		forum = Factory(:forum)
		login_as admin_user
		assert_difference('Forum.count', -1) do
			delete :destroy, :id => forum.id
		end
		assert_redirected_to forums_path
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class TopicsControllerTest < ActionController::TestCase

	def setup
		@topic = Factory(:topic)
	end

	test "should get index without login" do
		get :index, :forum_id => @topic.forum.id
		assert_response :success
		assert_not_nil assigns(:forum)
		assert_not_nil assigns(:topics)
	end


	test "should NOT get new without login" do
		get :new, :forum_id => @topic.forum.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get new with login" do
		login_as active_user
		get :new, :forum_id => @topic.forum.id
		assert_response :success
	end


	test "should NOT create topic without login" do
		assert_no_difference('Topic.count') do
			post :create, :forum_id => @topic.forum.id,
				:topic => { :name => 'My Topic Name' },
				:post	=> { :body => 'My Post Body' }
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create without topic name" do
		user = active_user
		login_as user
		assert_no_difference('Topic.count') do
			post :create, :forum_id => @topic.forum.id,
				:topic => Factory.attributes_for(:topic).merge(:name => ''),
				:post	=> Factory.attributes_for(:post)
		end
		assert_equal assigns(:topic).user, user
		assert_equal assigns(:post).user,	user
		assert_response :success
		assert_template 'new'
		assert_not_nil flash[:error]
	end

	test "should create topic with login" do
		user = active_user
		login_as user
		assert_difference('Topic.count', +1) do
			post :create, :forum_id => @topic.forum.id,
				:topic => Factory.attributes_for(:topic),
				:post	=> Factory.attributes_for(:post)
		end
		assert_equal assigns(:topic).user, user
		assert_equal assigns(:post).user,	user
		assert_redirected_to topic_posts_path(assigns(:topic))
	end


	test "should show topic without login" do
		get :show, :id => @topic.id
		assert_redirected_to topic_posts_path(assigns(:topic))
	end


	test "should NOT get edit without login" do
		get :edit, :id => @topic.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		login_as active_user
		get :edit, :id => @topic.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		login_as @topic.user
		get :edit, :id => @topic.id
		assert_response :success
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => @topic.id
		assert_response :success
	end


	test "should NOT update topic without login" do
		put :update, :id => @topic.id, :topic => Factory.attributes_for(:topic)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update topic without owner login" do
		login_as active_user
		put :update, :id => @topic.id, :topic => Factory.attributes_for(:topic)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update topic without name" do
		login_as @topic.user
		put :update, :id => @topic.id, :topic => Factory.attributes_for(:topic).merge(:name => '')
		assert_equal( assigns(:topic).user, @topic.user )
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update topic with owner login" do
		login_as @topic.user
		put :update, :id => @topic.id, :topic => Factory.attributes_for(:topic)
		assert_equal( assigns(:topic).user, @topic.user )
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should update topic with admin login" do
		login_as admin_user
		put :update, :id => @topic.id, :topic => Factory.attributes_for(:topic)
		assert_equal( assigns(:topic).user, @topic.user )
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end


	test "should destroy topic without login" do
		assert_no_difference('Topic.count') do
			delete :destroy, :id => @topic.id
		end
		assert_redirected_to login_path
	end

	test "should destroy topic without owner login" do
		login_as active_user
		assert_no_difference('Topic.count') do
			delete :destroy, :id => @topic.id
		end
		assert_redirected_to root_path
	end

	test "should destroy topic with owner login" do
		login_as @topic.user
		assert_difference('Topic.count', -1) do
			delete :destroy, :id => @topic.id
		end
		assert_redirected_to forum_topics_path( assigns(:forum) )
	end

	test "should destroy topic with admin login" do
		login_as admin_user
		assert_difference('Topic.count', -1) do
			delete :destroy, :id => @topic.id
		end
		assert_redirected_to forum_topics_path( assigns(:forum) )
	end

end

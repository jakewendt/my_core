require File.dirname(__FILE__) + '/../test_helper'

class PostsControllerTest < ActionController::TestCase

	def setup
		@post = Factory(:post)
	end

	test "should get index without login" do
		get :index, :topic_id => @post.topic.id
		assert_response :success
		assert_not_nil assigns(:posts)
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
	end

	test "should NOT get new without login" do
		get :new, :topic_id => @post.topic.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get new with login" do
		login_as active_user
		get :new, :topic_id => @post.topic.id
		assert_response :success
		assert_not_nil assigns(:topic)
		assert_not_nil assigns(:forum)
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
	end

	test "should NOT create post without login" do
		login_as nil
		assert_no_difference('Post.count') do
			post :create, :topic_id => @post.topic, :post => Factory.attributes_for(:post)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create post without body" do
		login_as active_user
		assert_no_difference('Post.count') do
			post :create, :topic_id => @post.topic, :post => Factory.attributes_for(:post).merge(:body => '')
		end
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'new'
	end

	test "should create post with login" do
		login_as active_user
		assert_difference('Post.count', +1) do
			post :create, :topic_id => @post.topic, :post => Factory.attributes_for(:post)
		end
		assert_not_nil assigns(:post)
		assert_not_nil assigns(:post).topic
		assert_equal assigns(:post).topic, @post.topic
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should NOT show post without login" do
		get :show, :id => @post.id
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should NOT show post with login" do
		login_as active_user
		get :show, :id => @post.id
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should NOT get edit without login" do
		get :edit, :id => @post.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		login_as active_user
		get :edit, :id => @post.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		login_as @post.user
		get :edit, :id => @post.id
		assert_response :success
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => @post.id
		assert_response :success
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
	end

	test "should NOT update post without login" do
		put :update, :id => @post.id, :post => Factory.attributes_for(:post)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update post without owner login" do
		login_as active_user
		put :update, :id => @post.id, :post => Factory.attributes_for(:post)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update post without body" do
		login_as @post.user
		put :update, :id => @post.id, :post => Factory.attributes_for(:post).merge(:body => '')
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end

	test "should update post with owner login" do
		login_as @post.user
		put :update, :id => @post.id, :post => Factory.attributes_for(:post)
		assert_equal assigns(:post).user,	@post.user
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should update post with admin login" do
		login_as admin_user
		put :update, :id => @post.id, :post => Factory.attributes_for(:post)
		assert_equal assigns(:post).user,	@post.user
		assert_equal assigns(:post),	@post
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should NOT destroy post without login" do
		assert_no_difference('Post.count') do
			delete :destroy, :id => @post.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy post without owner login" do
		login_as active_user
		assert_no_difference('Post.count') do
			delete :destroy, :id => @post.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy post with owner login" do
		login_as @post.user
		assert_difference('Post.count', -1) do
			delete :destroy, :id => @post.id
		end
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

	test "should destroy post with admin login" do
		login_as admin_user
		assert_difference('Post.count', -1) do
			delete :destroy, :id => @post
		end
		assert_equal assigns(:topic), @post.topic
		assert_equal assigns(:forum), @post.topic.forum
		assert_redirected_to topic_posts_path( assigns(:topic) )
	end

end

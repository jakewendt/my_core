require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

	def setup
		@comment = Factory(:comment, {
			:commentable => Factory(:stop)
		})
	end

	test "should NOT have new route" do
		assert_raise(ActionController::RoutingError){
			get :new, :stop_id => 1
		}
	end

	test "should NOT have create route" do
		assert_raise(ActionController::RoutingError){
			post :create, :stop_id => 1, :comment => Factory.attributes_for(:comment)
		}
	end

	test "should NOT have index route" do
		assert_raise(ActionController::RoutingError){
			get :index, :stop_id => 1
		}
	end

	test "should NOT have show route" do
		assert_raise(ActionController::RoutingError){
			get :show, :stop_id => 1, :id => 1
		}
	end

	test "should NOT get edit without login" do
		login_as nil
		get :edit, :id => @comment
		assert_nil assigns(:comment)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		login_as active_user
		get :edit, :id => @comment
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		login_as @comment.user
		get :edit, :id => @comment
		assert_not_nil assigns(:comment)
		assert_response :success
	end

	test "should get edit with commentable owner login" do
		login_as @comment.user
		get :edit, :id => @comment
		assert_not_nil assigns(:comment)
		assert_response :success
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => @comment
		assert_not_nil assigns(:comment)
		assert_response :success
	end

	test "should NOT update comment without login" do
		login_as nil
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_nil assigns(:comment)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update comment without owner login" do
		login_as active_user
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_not_nil assigns(:comment)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT update comment when update_attributes fails" do
		Comment.any_instance.stubs(:update_attributes).returns(false)
		login_as @comment.user
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_equal assigns(:comment).user_id, @comment.user.id
		assert_not_nil assigns(:comment)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update comment with owner login" do
		login_as @comment.user
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_equal assigns(:comment).user_id, @comment.user.id
		assert_not_nil assigns(:comment)
		assert_redirected_to @comment.commentable
	end

	test "should update comment with commentable owner login" do
		login_as @comment.user
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_equal assigns(:comment).user_id, @comment.user.id
		assert_not_nil assigns(:comment)
		assert_redirected_to @comment.commentable
	end

	test "should update comment with admin login" do
		login_as admin_user
		put :update, :id => @comment, :comment => Factory.attributes_for(:comment)
		assert_equal assigns(:comment).user_id, @comment.user.id
		assert_not_nil assigns(:comment)
		assert_redirected_to @comment.commentable
	end


	test "should NOT destroy comment without login" do
		login_as nil
		assert_no_difference('Comment.count') do
			delete :destroy, :id => @comment
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy comment without owner login" do
		login_as active_user
		assert_no_difference('Comment.count') do
			delete :destroy, :id => @comment
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should ajax destroy comment with owner login" do
		login_as @comment.user
		wants :js
		assert_difference('Comment.count', -1) do
			delete :destroy, :id => @comment
		end
		assert_not_nil assigns(:comment)
		assert_response :success
		assert_select_rjs :replace_html, "#comments_count"
		assert_select_rjs :remove, "#comment_#{(assigns(:comment).id)}"
	end

	test "should destroy comment with owner login" do
		login_as @comment.user
		assert_difference('Comment.count', -1) do
			delete :destroy, :id => @comment
		end
		assert_not_nil assigns(:comment)
		assert_redirected_to assigns(:comment).commentable
	end

	test "should destroy comment with commentable owner login" do
		login_as @comment.user
		assert_difference('Comment.count', -1) do
			delete :destroy, :id => @comment
		end
		assert_not_nil assigns(:comment)
		assert_redirected_to assigns(:comment).commentable
	end

	test "should destroy comment with admin login" do
		login_as admin_user
		assert_difference('Comment.count', -1) do
			delete :destroy, :id => @comment
		end
		assert_not_nil assigns(:comment)
		assert_redirected_to assigns(:comment).commentable
	end

end

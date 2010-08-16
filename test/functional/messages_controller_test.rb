require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase

	test "should NOT get index without login" do
		get :index
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should get index with login" do
		message = Factory(:message)
		login_as message.recipient
		get :index
		assert_response :success
		assert_not_nil assigns(:received_messages)
		assert_equal message.recipient.sent_messages.length, 0
		assert_equal message.recipient.received_messages.length, assigns(:received_messages).length
		assert_template 'index'
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
		assert_template 'new'
	end

	test "should NOT create message without login" do
		assert_no_difference('Message.count') do
			post :create, :message => Factory.attributes_for(:message)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create message when save fails" do
		recipient = active_user
		sender = active_user
		login_as sender
		Message.any_instance.stubs(:save).returns(false)
		assert_no_difference('Message.count') do
			post :create, :message => Factory.attributes_for(:message)
		end
		assert_template 'new'
		assert_not_nil flash[:error]
		assert_response :success
	end

	test "should create message with login" do
		recipient = active_user
		sender = active_user
		login_as sender
		assert_difference("User.find(#{sender.id}).sent_messages.length", 1) {
		assert_difference("User.find(#{recipient.id}).received_messages.length", 1) {
		assert_difference('Message.count', 1) {
			post :create, :message => Factory.attributes_for(:message, :recipient_id => recipient.id)
		} } }
		assert !assigns(:message).read
		assert_redirected_to message_path(assigns(:message))
	end

	test "should NOT show message without login" do
		message = Factory(:message)
		get :show, :id => message.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT show message with unrelated user login" do
		message = Factory(:message)
		login_as active_user
		get :show, :id => message.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should show message with sender login" do
		message = Factory(:message)
		login_as message.sender
		get :show, :id => message.id
		assert !assigns(:message).read
		assert_response :success
		assert_template 'show'
	end

	test "should show message with recipient login" do
		message = Factory(:message)
		login_as message.recipient
		get :show, :id => message.id
		assert assigns(:message).read
		assert_response :success
		assert_template 'show'
	end

	test "should show message with admin login" do
		message = Factory(:message)
		login_as admin_user
		get :show, :id => message.id
		assert !assigns(:message).read
		assert_response :success
		assert_template 'show'
	end

	test "should NOT get edit without login" do
		message = Factory(:message)
		get :edit, :id => message.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit with sender login" do
		message = Factory(:message)
		login_as message.sender
		get :edit, :id => message.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should NOT get edit with recipient login" do
		message = Factory(:message)
		login_as message.recipient
		get :edit, :id => message.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with admin login" do		#	although I don't know if this'll be used
		message = Factory(:message)
		login_as admin_user
		get :edit, :id => message.id
		assert_response :success
		assert_template 'edit'
	end


	test "should NOT update message without login" do
#		message = Factory(:message)
#		get :edit, :id => message.id
#		assert_not_nil flash[:error]
#		assert_redirected_to messages_path
	end

	test "should NOT update message with sender login" do

	end

	test "should NOT update message with recipient login" do

	end

	test "should NOT update message when update_attributes fails" do		#	again, I don't know if this'll be implemented
		message = Factory(:message)
		login_as admin_user
		Message.any_instance.stubs(:update_attributes).returns(false)
		put :update, :id => message.id, :message => Factory.attributes_for(:message)
		assert_response :success
		assert_template 'edit'
		assert_not_nil flash[:error]
	end

	test "should update message with admin login" do		#	again, I don't know if this'll be implemented
		message = Factory(:message)
		login_as admin_user
		put :update, :id => message.id, :message => Factory.attributes_for(:message)
		assert_redirected_to message_path(assigns(:message))
	end



	test "should destroy message with admin login" do
		message = Factory(:message)
		login_as admin_user
		assert_difference('Message.count', -1) do
			delete :destroy, :id => message.id
		end
		assert_redirected_to messages_path
	end


end

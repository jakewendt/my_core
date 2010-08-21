class MessagesController < ApplicationController
	before_filter :login_required
	before_filter :check_administrator_role, :only => [:edit, :update, :destroy]
	before_filter :require_sender_or_recipient, :only => :show

	def index
		@page_title = "My Messages"
		@sent_messages     = current_user.sent_messages
		@received_messages = current_user.received_messages
	end

	def show
		@page_title = "Message"
		@message.update_attribute(:read, true) if @message.recipient == current_user
	end

	def new
		@page_title = "Create New Message"
		@message = current_user.sent_messages.new({
			:recipient_id => params[:recipient_id],
			:subject => params[:subject]
		})
	end

	def edit
		@page_title = "Edit Message"
		@message = Message.find(params[:id])
	end

	def create
		@message = current_user.sent_messages.new(params[:message])
		if @message.save
			flash[:notice] = 'Message was successfully created.'
			redirect_to(@message)
		else
			flash[:error] = 'There was a problem saving your message.'
			render :action => "new"
		end
	end

	def update
		@message = Message.find(params[:id])

		if @message.update_attributes(params[:message])
			flash[:notice] = 'Message was successfully updated.'
			redirect_to(@message)
		else
			flash[:error] = 'There was a problem updating the message.'
			render :action => "edit"
		end
	end

	def destroy
		@message = Message.find(params[:id])
		@message.destroy
		redirect_to(messages_url)
	end

protected

	def require_sender_or_recipient
		@message = Message.find(params[:id])
		unless ( [@message.sender,@message.recipient].include?(current_user) ||
				current_user.has_role?('administrator') )
#			flash[:notice] = "You do not have permission to view this message"
			permission_denied("You do not have permission to view this message")
		end
	end

end

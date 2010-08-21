class EmailsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required

	def new
		@page_title = "Compose Email"
		params[:recipient_id] ||= User.find_by_login('admin').id
		@email = Email.new({ 
			:recipient_id => params[:recipient_id] 
		})
	end

	def create
		@email = Email.new(params[:email])
		@email.sender_id = current_user.id
		@email.recipient_id ||= User.find_by_login('admin').id
		@email.save!
		UserMailer.deliver_email(@email)
		flash[:notice] = 'Your email was sent.'
		redirect_to_referer_or_default(root_path)
	rescue ActiveRecord::RecordInvalid
		# I don't think that this is EVER done
		# If you read this and know how to determine whether
		# there was a problem, please contact me.	ThanX
		flash.now[:error] = 'There was a problem saving/sending your email.'
		render :action => 'new'
	end

#	def index
#	end

end

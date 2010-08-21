class AccountsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => :show
	before_filter :not_logged_in_required, :only => :show

	# Activate action
	def show
		# Uncomment and change paths to have user logged in after activation - not recommended
		#self.current_user = User.find_and_activate!(params[:id])
		User.find_and_activate!(params[:id])
		flash[:notice] = "Your account has been activated! You can now login."
		redirect_to login_path
	rescue ::ArgumentError
#		rescue User::ArgumentError
#		This is what generates ...
#		app/controllers/accounts_controller.rb:14: warning: toplevel constant ArgumentError referenced by User::ArgumentError
#		in all the tests
#		removing the User prefix makes the errors go away
#		and doesn't cause any tests to fail
		flash[:error] = 'Activation code not found. Please try creating a new account.'
		redirect_to new_user_path 
	rescue User::ActivationCodeNotFound
		flash[:error] = 'Activation code not found. Please try creating a new account.'
		redirect_to new_user_path
	rescue User::AlreadyActivated
		flash[:error] = 'Your account has already been activated. You can log in below.'
		redirect_to login_path
	end

	def edit
		@page_title = "Change Password"
	end

	# Change password action	
	def update
# removed to make restful (should actually be put)
#		return unless request.post?
		if User.authenticate(current_user.login, params[:old_password])
			if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
				current_user.password_confirmation = params[:password_confirmation]
				current_user.password = params[:password]				
				if current_user.save
					flash[:notice] = "Password successfully updated."
					redirect_to user_path(current_user)
				else
					flash.now[:error] = "An error occured, your password was not changed."
					render :action => 'edit'
				end
			else
				flash.now[:error] = "New password does not match the password confirmation."
				@old_password = params[:old_password]
				render :action => 'edit'			
			end
		else
			flash.now[:error] = "Your old password is incorrect."
			render :action => 'edit'
		end 
	end


#	def index
#		redirect_to root_url
#	end
#
#	def new
#		redirect_to root_url
#	end
#
#	def create
#		redirect_to root_url
#	end
#
#	def destroy
#		redirect_to root_url
#	end

end

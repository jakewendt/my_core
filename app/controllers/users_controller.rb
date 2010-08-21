class UsersController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :not_logged_in_required, :only => [:new, :create] 
	before_filter :login_required, :only => [:show, :edit, :update]
	before_filter :check_administrator_role, :only => [:index, :destroy, :enable]
	before_filter :user_or_current_user, :only => [:show, :edit, :update]

	def index
		@page_title = "Users"
		@users = User.find(:all, :order => "last_login DESC")
	end

	def show
		@page_title = @user.login
	end

	def new
		@page_title = "Create New User"
		@user = User.new
	end

	def create
		cookies.delete :auth_token
		@user = User.new(params[:user])
		@user.last_login = Time.now
		@user.save!
		#Uncomment to have the user logged in after creating an account - Not Recommended
		#self.current_user = @user
		flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
		redirect_to login_path		
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating your account."
		render :action => 'new'
	end

	def edit
		@page_title = "Edit User"
	end

	def update
		@user.update_attributes!(params[:user])
		flash[:notice] = "User updated"
		redirect_to user_path(@user)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating user."
		render :action => 'edit'
	end

	def destroy		 # this is really "disable"
		@user = User.find(params[:id])
		if @user.update_attribute(:enabled, false)
			flash[:notice] = "User disabled"
		else
			flash[:error] = "There was a problem disabling this user."
		end
		redirect_to users_path
	end

	def enable
		@user = User.find(params[:id])
		if @user.update_attribute(:enabled, true)
			flash[:notice] = "User enabled"
		else
			flash[:error] = "There was a problem enabling this user."
		end
		redirect_to users_path
	end

protected

	def user_or_current_user
		if current_user.has_role?('administrator')
			@user = User.find(params[:id])
		else
			@user = current_user
		end
# ALL THESE INCLUSIONS SERIOUSLY SLOWS THINGS DOWN!
#		@user = User.find(id, :include => [ :blogs, :resumes, :trips, :boards, :lists ])
		@blogs   = @user.blogs
		@resumes = @user.resumes
		@trips   = @user.trips
		@boards  = @user.boards
		@lists   = @user.lists
		@notes   = @user.notes
	end

end

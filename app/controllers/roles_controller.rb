class RolesController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :check_administrator_role

	def index
		@user = User.find(params[:user_id], :include => :roles)
		@all_roles = Role.find(:all)
	end

	def update
		@user = User.find(params[:user_id], :include => :roles)
		@role = Role.find(params[:id])
		unless @user.has_role?(@role.name)
			@user.roles << @role
		end
		redirect_to user_roles_path(@user)
	end

	def destroy
		@user = User.find(params[:user_id], :include => :roles)
		@role = Role.find(params[:id])
		if @user.has_role?(@role.name)
			@user.roles.delete(@role)
		end
		if @user == current_user
			redirect_to user_path(@user)
		else
			redirect_to user_roles_path(@user)
		end
	end

#	def show
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
#	def edit
#		redirect_to root_url
#	end

end

class CreatorsController < ApplicationController
	before_filter :login_required
	before_filter :get_creator, :except => :index
	before_filter :require_owner, :except => :index

	def index
		@creators = current_user.creators
	end

	def show
		redirect_to(assets_path(:creator => @creator.name))
	end

	def edit
	end

	def update
		@creator.update_attributes!(params[:creator])
		flash[:notice] = 'Creator was successfully updated.'
		redirect_to(@creator)
	rescue
		flash.now[:error] = 'Creator update failed.'
		render :action => "edit"
	end

	def destroy
		@creator.destroy
		redirect_to(creators_url)
	end

protected

	def get_creator
		@creator = Creator.find(params[:id])
	end

end

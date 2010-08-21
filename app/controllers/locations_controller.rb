class LocationsController < ApplicationController
	before_filter :login_required
	before_filter :get_location, :except => :index
	before_filter :require_owner, :except => :index

	def index
		@locations = current_user.locations
	end

	def show
		redirect_to(assets_path(:location => @location.name))
	end

	def edit
	end

	def update
		@location.update_attributes!(params[:location])
		flash[:notice] = 'Location was successfully updated.'
		redirect_to(@location)
	rescue
		flash.now[:error] = 'Location update failed.'
		render :action => "edit"
	end

	def destroy
		@location.destroy
		redirect_to(locations_url)
	end

protected

	def get_location
		@location = Location.find(params[:id])
	end

end

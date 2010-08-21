class TripsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :show ]
	before_filter :get_trip, :except => [ :index, :new, :create ]
	# requires current_user and @trip
	before_filter :require_owner, :only => [ :edit, :update, :confirm_destroy, :destroy ]
	before_filter :check_trip_public, :only => [ :show ]
	before_filter :check_pdf_download, :only => [ :index ]

	def confirm_destroy
	end

	def index
		@page_title = "Trips"
		@trips = Trip.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=trips_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		@page_title = @trip.title
		respond_to do |format|
			format.html #{ render :layout => "showtrip" } # show.html.erb
			format.rss	#{ render :layout => false, :rss => @trip }
			format.txt {
				headers["Content-disposition"] = "attachment; filename=trip_#{@trip.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.pdf { prawnto :filename => "trip_#{@trip.id}_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

	def new
		@page_title = "Create New Trip"
		@trip = Trip.new
	end

	def create
		@trip = current_user.trips.new(params[:trip])
		@trip.save!
		flash[:notice] = 'Trip was successfully created.'
		redirect_to edit_trip_url(@trip)
	rescue
		flash.now[:error] = 'Trip creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit Trip"
	end

	def update
		# Found this method online at ...
		# http://wiki.rubyonrails.org/rails/pages/HowToUpdateModelsWithHasManyRelationships
		# What's the practical difference here between .collect or .each?
		update_result = @trip.update_attributes(params[:trip])
		@trip.stops.each do |stop|
			result = stop.update_attributes(params[:stop][stop.id.to_s]) if params[:stop]
			update_result &&= result
		end
		if update_result
			redirect_to(@trip)
		else
			flash.now[:error] = 'Trip update failed.'
			render :action => 'edit'
		end
	end

	def destroy
		@trip.destroy
		respond_to do |format|
			format.html { redirect_to(trips_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@trip)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#trips_count') ) {"
					page.replace_html "trips_count", @trip.user.trips.count
					page << "}"
				end
			end
		end
	end

protected

	def get_trip
		@trip = Trip.find(params[:id], :include => :stops )
	end

	def check_trip_public
		check_public(@trip)
	end

end

class StopsController < ApplicationController
	#	index, show, new, edit, create, update, destroy, update_latlng
	before_filter :login_required, :except => [ :show ]
	before_filter :get_stop, :except => [ :index, :create ]
	# requires current_user and @trip
	before_filter :require_owner,		 :except => [ :create, :show, :index, :create_comment ]
	before_filter :check_trip_public, :only	 => [ :show ]

	add_create_comment :stop
	add_photoability	 :stop

	def show
		@next = @stop.lower_item
		@previous = @stop.higher_item
		@page_title = @stop.title
	end

	def update_latlng
		@stop.lat = params[:lat]
		@stop.lng = params[:lng]
		@stop.save
#	TODO
#	add a respond_to block
	end

	def edit
		@page_title = "Edit Stop"
		@photoable = @stop
	end

	def update
		# Found this method online at ...
		# http://wiki.rubyonrails.org/rails/pages/HowToUpdateModelsWithHasManyRelationships
		# What's the practical difference here between .collect or .each
		update_result = @stop.update_attributes(params[:stop])
#		@stop.photos.collect do |photo|
		@stop.photos.each do |photo|
			# I don't understand why I need this "if"
			# If there aren't any magnets, it shouldn't be here?
			if params[:photo]
				result = photo.update_attributes(params[:photo][photo.id.to_s])
				update_result &&= result
			end
		end

#	TODO
#	cleanup

# I removed this because I don't think that I need it anymore,
# but we'll see. This was NOT uploaded 080707
#		if params[:image] && !params[:image]['filename'].blank?
#			images = Image.new(params[:image])
#			@stop.images << images
#			@stop.save
#		end 

		if update_result
			redirect_to(@stop)
		else
			flash.now[:error] = 'Stop update failed.'
			render :action => 'edit'
		end 
	end

	def destroy
		@stop.destroy
		respond_to do |format|
			format.html { redirect_to(trip_url(@stop.trip)) }
			format.js { render(:update){|page| page.remove dom_id(@stop) } }
		end
	end

	def order
		# use move to top (not bottom) as the list is inverted on the page
		params[:stops].each { |id| @trip.stops.find(id).move_to_top }
		respond_to do |format|
#	TODO
#			format.html {}
			format.js { render :text => '' }
		end
	end

	def new
		@page_title = "Create New Stop"
		if @trip.stops_count > 0
			last_stop = @trip.stops.last
			lat = last_stop.lat
			lng = last_stop.lng
		else
			lat = 39
			lng = -95
		end
		@stop = Stop.new({
			:lat => lat,
			:lng => lng,
			:title => "Next Stop"
		})
		@trip.stops << @stop
		@trip.save
#	TODO
#	add a respond_to block
	end

protected

	def get_stop
		@host = Socket.gethostname	# required for google maps api
		if params[:trip_id]
			@trip  = Trip.find(params[:trip_id], :include => :stops)
			@stops = @trip.stops
			@stop  = @stops.find(params[:id]) if params[:id]
		else
			@stop  = Stop.find( params[:id], :include => :photos )
			@trip  = @stop.trip
		end
	end 

	def check_trip_public
		check_public(@trip)
	end

end

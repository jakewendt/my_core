module LocationsHelper

	def locations_for_select
		options_for_select( 
			[['Apply New Location Filter',nil]] + 
			current_user.locations.collect{|c|
				[c.name,c.name]
			}.reject{|c|
				params[:location].include?(c[0]) if params[:location]
			}
		)
	end

end

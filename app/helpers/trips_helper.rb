module TripsHelper

	def classes_for_trip(trip)
		classes = ['row']
		classes.push('otheruser') if trip.user_id != current_user.id
		classes.push('public') if trip.public
		classes.join(' ')
	end

#	def trip_menu(trip)
#		menu_items = [
#			link_to( 'Export as TXT', trip_path(trip, :format => :txt) ),
#			link_to( 'Export as PDF', trip_path(trip, :format => :pdf) )
#		]
#		menu_items.push(
#			link_to( 'Edit', edit_trip_path(trip) ),
#			"<hr/>",
#			link_to( 'Destroy', trip_path(trip),
#				:confirm => "Delete #{trip.title}?\nAre you sure?",
#				:method => :delete ) ) if editable?(trip)
#		css_menu('Trip',menu_items)
#	end

end

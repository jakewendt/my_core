require File.dirname(__FILE__) + '/../test_helper'

class TripsControllerTest < ActionController::TestCase

	add_core_tests( :trip, { :except => [ :update_js ] } )
	add_common_search_tests( :trip )
	add_rss_feed_tests 'trip_with_stops'
	add_pdf_downloadability_tests 'trip_with_stops_with_photos_and_comments'
	add_txt_downloadability_tests 'trip_with_stops'

	test "should update trip with stops" do
		trip = trip_with_stops
		stops = {}
		trip.stops.each do |stop|
			stops[stop.id.to_s] = { 'title' => 'New Stop Title' }
		end
		login_as trip.user
		put :update, :id => trip.id, :stop => stops
		assert_redirected_to trip
	end

end

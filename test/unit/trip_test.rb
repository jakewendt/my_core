require File.dirname(__FILE__) + '/../test_helper'

class TripTest < ActiveSupport::TestCase
	add_taggability_unit_tests "Factory(:trip)"
	add_common_search_unit_tests :trip

	test "should create trip" do
		assert_difference 'Trip.count' do
			trip = create_trip
			assert !trip.new_record?, "#{trip.errors.full_messages.to_sentence}"
		end
	end

	test "should require title" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:title => nil)
			assert trip.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:title => 'Hey')
			assert trip.errors.on(:title)
		end
	end

	test "should require numerical lat" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:lat => nil )
			assert trip.errors.on(:lat)
		end
	end

	test "should require numerical lng" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:lng => nil )
			assert trip.errors.on(:lng)
		end
	end

	test "should require numerical zoom" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:zoom => nil )
			assert trip.errors.on(:zoom)
		end
	end

	test "should require integer zoom" do
		assert_no_difference 'Trip.count' do
			trip = create_trip(:zoom => 5.5 )
			assert trip.errors.on(:zoom)
		end
	end

	test "should require user" do
		assert_no_difference 'Trip.count' do
			trip = create_trip( {}, false )
			assert trip.errors.on(:user_id)
		end
	end

protected

	def create_trip(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:trip,options)
		record.save
		record
	end

end

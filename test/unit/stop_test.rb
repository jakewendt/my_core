require File.dirname(__FILE__) + '/../test_helper'

class StopTest < ActiveSupport::TestCase

	test "should create stop" do
		assert_difference 'Stop.count' do
			stop = create_stop
			assert !stop.new_record?, "#{stop.errors.full_messages.to_sentence}"
			assert_equal stop.user, stop.trip.user
		end
	end

	test "should require title" do
		assert_no_difference 'Stop.count' do
			stop = create_stop(:title => nil)
			assert stop.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Stop.count' do
			stop = create_stop(:title => 'Hey')
			assert stop.errors.on(:title)
		end
	end

	test "should require numerical lng" do
		assert_no_difference 'Stop.count' do
			stop = create_stop(:lng => nil )
			assert stop.errors.on(:lng)
		end
	end

	test "should require numerical lat" do
		assert_no_difference 'Stop.count' do
			stop = create_stop(:lat => nil )
			assert stop.errors.on(:lat)
		end
	end

	test "should require trip" do
		assert_no_difference 'Stop.count' do
			stop = create_stop( {}, false )
			assert stop.errors.on(:trip_id)
		end
	end

protected

	def create_stop(options = {}, addtrip = true )
		options[:trip] = nil unless addtrip
		record = Factory.build(:stop,options)
		record.save
		record
	end

end

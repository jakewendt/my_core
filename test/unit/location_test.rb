require File.dirname(__FILE__) + '/../test_helper'

class LocationTest < ActiveSupport::TestCase

	test "should create location" do
		assert_difference 'Location.count' do
			location = create_location
			assert !location.new_record?, "#{location.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Location.count' do
			location = create_location(:name => nil)
			assert location.errors.on(:name)
		end
	end

	test "should require name not begin with a bang" do
		assert_no_difference 'Location.count' do
			location = create_location(:name => "!bang")
			assert location.errors.on(:name)
		end
	end

	test "should require unique name" do
		assert_difference('Location.count',1) do
			location = create_location({:name => "Test Name", :user_id => 1})
			assert !location.new_record?, "#{location.errors.full_messages.to_sentence}"
			location = create_location({:name => "Test Name", :user_id => 1})
			assert location.errors.on(:name)
		end
	end

	test "should require user" do
		assert_no_difference 'Location.count' do
			location = create_location( :user => nil )
			assert location.errors.on(:user_id)
		end
	end

	test "should find or create" do
		assert_difference( 'Location.count', 1 ) do
			@location1 = Location.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert_no_difference( 'Location.count' ) do
			@location2 = Location.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert @location1 == @location2
	end

	test "should raise error if multiple named locations" do
		location1 = create_location(:name => 'Testing')
		location2 = create_location(:name => 'Testing')
		assert_no_difference( 'Location.count' ) do
			assert_raises(Location::MultipleLocationsFound){Location.find_or_create(:name => 'Testing')}
		end
	end

protected

	def create_location(options = {})
		record = Factory.build(:location,options)
		record.save
		record
	end

end

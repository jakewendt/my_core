require File.dirname(__FILE__) + '/../test_helper'

class SchoolTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :school

	test "should create school" do
		assert_difference 'School.count' do
			school = create_school
			assert !school.new_record?, "#{school.errors.full_messages.to_sentence}"
			assert_equal school.user, school.resume.user
		end
	end

	test "should require name" do
		assert_no_difference 'School.count' do
			school = create_school( :name => nil )
			assert school.errors.on(:name)
		end
	end

	test "should require start date" do
		assert_no_difference 'School.count' do
			school = create_school( :start_date_string => nil )
#			assert school.errors.on(:start_date)
			assert school.errors.on(:start_date_string)
		end
	end

	test "should NOT require end date" do
		assert_difference 'School.count' do
			school = create_school( :end_date_string => nil )
			assert !school.new_record?, "#{school.errors.full_messages.to_sentence}"
		end
	end

	test "should require location" do
		assert_no_difference 'School.count' do
			school = create_school( :location => nil )
			assert school.errors.on(:location)
		end
	end

	test "should NOT require degree" do
		assert_difference 'School.count' do
			school = create_school( :degree => nil )
			assert !school.new_record?, "#{school.errors.full_messages.to_sentence}"
		end
	end

	test "should NOT require description" do
		assert_difference 'School.count' do
			school = create_school( :description => nil )
			assert !school.new_record?, "#{school.errors.full_messages.to_sentence}"
		end
	end

	test "should require resume" do
		assert_no_difference 'School.count' do
			school = create_school( {}, false )
			assert school.errors.on(:resume_id)
		end
	end

	test "should return month year on end_date_to_s with date" do
		school = create_school(:end_date_string => "January 1, 2001")
		assert_equal school.end_date_to_s, "Jan 2001"
	end

	test "should return Present on end_date_to_s when empty" do
		school = create_school
		assert_equal school.end_date_to_s, "Present"
	end

protected

	def create_school(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:school,options)
		record.save
		record
	end

end

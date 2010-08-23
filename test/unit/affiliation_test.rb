require File.dirname(__FILE__) + '/../test_helper'

class AffiliationTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :affiliation

	test "should create affiliation" do
		assert_difference 'Affiliation.count' do
			affiliation = create_affiliation
			assert !affiliation.new_record?, "#{affiliation.errors.full_messages.to_sentence}"
			assert_equal affiliation.user, affiliation.resume.user
		end
	end

	test "should require organization" do
		assert_no_difference 'Affiliation.count' do
			affiliation = create_affiliation( :organization => nil )
			assert affiliation.errors.on(:organization)
		end
	end

	test "should require start date" do
		assert_no_difference 'Affiliation.count' do
			affiliation = create_affiliation( :start_date_string => nil )
#			assert affiliation.errors.on(:start_date)
			assert affiliation.errors.on(:start_date_string)
		end
	end

	test "should NOT require end date" do
		assert_difference 'Affiliation.count' do
			affiliation = create_affiliation( :end_date => nil )
			assert !affiliation.new_record?, "#{affiliation.errors.full_messages.to_sentence}"
		end
	end

	test "should require relationship" do
		assert_no_difference 'Affiliation.count' do
			affiliation = create_affiliation( :relationship => nil )
			assert affiliation.errors.on(:relationship)
		end
	end

	test "should require resume" do
		assert_no_difference 'Affiliation.count' do
			affiliation = create_affiliation( {}, false )
			assert affiliation.errors.on(:resume_id)
		end
	end

	test "should return month year on end_date_to_s with date" do
#		affiliation = create_affiliation(:end_date_string => "January 1, 2001")
		affiliation = create_affiliation(:end_date_string => "January 1 2001")
		assert_equal affiliation.end_date_to_s, "Jan 2001"
	end

	test "should return Present on end_date_to_s when empty" do
		affiliation = create_affiliation
		assert_equal affiliation.end_date_to_s, "Present"
	end

protected

	def create_affiliation(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:affiliation, options)
		record.save
		record
	end

end

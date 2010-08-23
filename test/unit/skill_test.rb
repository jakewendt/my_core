require File.dirname(__FILE__) + '/../test_helper'

class SkillTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :skill

	test "should create skill" do
		assert_difference 'Skill.count' do
			skill = create_skill
			assert !skill.new_record?, "#{skill.errors.full_messages.to_sentence}"
			assert_equal skill.user, skill.resume.user
		end
	end

	test "should require name" do
		assert_no_difference 'Skill.count' do
			skill = create_skill( :name => nil )
			assert skill.errors.on(:name)
		end
	end

	test "should require start date" do
		assert_no_difference 'Skill.count' do
			skill = create_skill( :start_date_string => nil )
#			assert skill.errors.on(:start_date)
			assert skill.errors.on(:start_date_string)
		end
	end

	test "should NOT require end date" do
		assert_difference 'Skill.count' do
			skill = create_skill( :end_date_string => nil )
			assert !skill.new_record?, "#{skill.errors.full_messages.to_sentence}"
		end
	end

	test "should require level id" do
		assert_no_difference 'Skill.count' do
			skill = create_skill( :level_id => nil )
			assert skill.errors.on(:level_id)
		end
	end

	test "should require resume" do
		assert_no_difference 'Skill.count' do
			skill = create_skill( {}, false )
			assert skill.errors.on(:resume_id)
		end
	end

	test "should return month year on end_date_to_s with date" do
#		skill = create_skill(:end_date_string => "January 1, 2001")
		skill = create_skill(:end_date_string => "January 1 2001")
		assert_equal skill.end_date_to_s, "Jan 2001"
	end

	test "should return Present on end_date_to_s when empty" do
		skill = create_skill
		assert_equal skill.end_date_to_s, "Present"
	end

protected

	def create_skill(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:skill,options)
		record.save
		record
	end

end

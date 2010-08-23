require File.dirname(__FILE__) + '/../test_helper'

class JobTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :job

	test "should create job" do
		assert_difference 'Job.count' do
			job = create_job
			assert !job.new_record?, "#{job.errors.full_messages.to_sentence}"
			assert_equal job.user, job.resume.user
		end
	end

	test "should require title" do
		assert_no_difference 'Job.count' do
			job = create_job( :title => nil )
			assert job.errors.on(:title)
		end
	end

	test "should require start date" do
		assert_no_difference 'Job.count' do
			job = create_job( :start_date_string => nil )
#			assert job.errors.on(:start_date)
			assert job.errors.on(:start_date_string)
		end
	end

	test "should NOT require end date" do
		assert_difference 'Job.count' do
			job = create_job( :end_date_string => nil )
			assert !job.new_record?, "#{job.errors.full_messages.to_sentence}"
		end
	end

	test "should require company" do
		assert_no_difference 'Job.count' do
			job = create_job( :company => nil )
			assert job.errors.on(:company)
		end
	end

	test "should require location" do
		assert_no_difference 'Job.count' do
			job = create_job( :location => nil )
			assert job.errors.on(:location)
		end
	end

	test "should NOT require description" do
		assert_difference 'Job.count' do
			job = create_job( :description => nil )
			assert !job.new_record?, "#{job.errors.full_messages.to_sentence}"
		end
	end

	test "should require resume" do
		assert_no_difference 'Job.count' do
			job = create_job( {}, false )
			assert job.errors.on(:resume_id)
		end
	end

	test "should return month year on end_date_to_s with date" do
#		job = create_job(:end_date_string => "January 1, 2001")
		job = create_job(:end_date_string => "January 1 2001")
		assert_equal job.end_date_to_s, "Jan 2001"
	end

	test "should return Present on end_date_to_s when empty" do
		job = create_job
		assert_equal job.end_date_to_s, "Present"
	end

protected

	def create_job(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:job,options)
		record.save
		record
	end

end

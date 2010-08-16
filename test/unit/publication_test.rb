require File.dirname(__FILE__) + '/../test_helper'

class PublicationTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :publication

	test "should create publication" do
		assert_difference 'Publication.count' do
			publication = create_publication
			assert !publication.new_record?, "#{publication.errors.full_messages.to_sentence}"
			assert_equal publication.user, publication.resume.user
		end
	end

	test "should require name" do
		assert_no_difference 'Publication.count' do
			publication = create_publication( :name => nil )
			assert publication.errors.on(:name)
		end
	end

	test "should require contribution" do
		assert_no_difference 'Publication.count' do
			publication = create_publication( :contribution => nil )
			assert publication.errors.on(:contribution)
		end
	end

	test "should require title" do
		assert_no_difference 'Publication.count' do
			publication = create_publication( :title => nil )
			assert publication.errors.on(:title)
		end
	end

	test "should require date" do
		assert_no_difference 'Publication.count' do
			publication = create_publication( :date_string => nil )
#			assert publication.errors.on(:date)
			assert publication.errors.on(:date_string)
		end
	end

	test "should NOT require url" do
		assert_difference 'Publication.count' do
			publication = create_publication( :url => nil )
			assert !publication.new_record?, "#{publication.errors.full_messages.to_sentence}"
		end
	end

	test "should require resume" do
		assert_no_difference 'Publication.count' do
			publication = create_publication( {}, false )
			assert publication.errors.on(:resume_id)
		end
	end

protected

	def create_publication(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:publication,options)
		record.save
		record
	end

end

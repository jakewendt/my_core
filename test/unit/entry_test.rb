require File.dirname(__FILE__) + '/../test_helper'

class EntryTest < ActiveSupport::TestCase

	test "should create entry" do
		assert_difference 'Entry.count' do
			entry = create_entry
			assert !entry.new_record?, "#{entry.errors.full_messages.to_sentence}"
			assert_equal entry.user, entry.blog.user
		end
	end

	test "should require title" do
		assert_no_difference 'Entry.count' do
			entry = create_entry(:title => nil)
			assert entry.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Entry.count' do
			entry = create_entry(:title => 'Hey')
			assert entry.errors.on(:title)
		end
	end

	test "should require body" do
		assert_no_difference 'Entry.count' do
			entry = create_entry(:body => nil)
			assert entry.errors.on(:body)
		end
	end

	test "should require 4 char body" do
		assert_no_difference 'Entry.count' do
			entry = create_entry(:body => 'Hey')
			assert entry.errors.on(:body)
		end
	end

	test "should require blog" do
		assert_no_difference 'Entry.count' do
			entry = create_entry( {}, false )
			assert entry.errors.on(:blog_id)
		end
	end

protected

	def create_entry(options = {}, addblog = true )
		options[:blog] = nil unless addblog
		record = Factory.build(:entry,options)
		record.save
		record
	end

end

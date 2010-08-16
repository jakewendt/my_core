require File.dirname(__FILE__) + '/../test_helper'

class TopicTest < ActiveSupport::TestCase

	test "should create topic" do
		assert_difference 'Topic.count' do
			topic = create_topic
			assert !topic.new_record?, "#{topic.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Topic.count' do
			topic = create_topic(:name => nil)
			assert topic.errors.on(:name)
		end
	end

	test "should require 4 char name" do
		assert_no_difference 'Topic.count' do
			topic = create_topic(:name => 'Hey')
			assert topic.errors.on(:name)
		end
	end

	test "should require user" do
		assert_no_difference 'Topic.count' do
			topic = create_topic( {}, false )
			assert topic.errors.on(:user_id)
		end
	end

	test "should require forum" do
		assert_no_difference 'Topic.count' do
			topic = create_topic( {}, true, false )
			assert topic.errors.on(:forum_id)
		end
	end

protected

	def create_topic(options = {}, adduser = true, addforum = true )
		options[:user] = nil unless adduser
		options[:forum] = nil unless addforum
		record = Factory.build(:topic,options)
		record.save
		record
	end

end

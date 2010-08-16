require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

	test "should create post" do
		assert_difference 'Post.count' do
			post = create_post
			assert !post.new_record?, "#{post.errors.full_messages.to_sentence}"
		end
	end

	test "should require body" do
		assert_no_difference 'Post.count' do
			post = create_post(:body => nil)
			assert post.errors.on(:body)
		end
	end

	test "should require 4 char body" do
		assert_no_difference 'Post.count' do
			post = create_post(:body => 'Hey')
			assert post.errors.on(:body)
		end
	end

	test "should require user" do
		assert_no_difference 'Post.count' do
			post = create_post( {}, false )
			assert post.errors.on(:user_id)
		end
	end

	test "should NOT require topic" do
		assert_difference 'Post.count' do
			post = create_post( {}, true, false )
			assert !post.new_record?, "#{post.errors.full_messages.to_sentence}"
		end
	end

protected

	def create_post(options = {}, adduser = true, addtopic = true )
		options[:user] = nil unless adduser
		options[:topic] = nil unless addtopic
		record = Factory.build(:post,options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase

	test "should create comment" do
		assert_difference 'Comment.count' do
			comment = create_comment
			assert !comment.new_record?, "#{comment.errors.full_messages.to_sentence}"
		end
	end

#	test "should require body" do
#		assert_no_difference 'Comment.count' do
#			comment = create_comment(:body => nil)
#			assert comment.errors.on(:body)
#		end
#	end
#
#	test "should require 4 char body" do
#		assert_no_difference 'Comment.count' do
#			comment = create_comment(:body => 'Hey')
#			assert comment.errors.on(:body)
#		end
#	end
#
#	test "should require user" do
#		assert_no_difference 'Comment.count' do
#			comment = create_comment( {}, false )
#			assert comment.errors.on(:user_id)
#		end
#	end

# requires a commentable, but the erroring isn't a validation error
#	test "should require stop" do
#		assert_no_difference 'Comment.count' do
#			comment = create_comment( {}, true, false )
#			assert comment.errors.on(:stop_id)
#		end
#	end


protected

	def create_comment(options = {}, adduser = true, addstop = true )
		options[:user] = nil unless adduser
		options[:commentable] = Factory(:stop) if addstop
		record = Factory.build(:comment, options)
		record.save
		record
	end

end

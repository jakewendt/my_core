require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase

	test "should create message" do
		assert_difference 'Message.count' do
			message = Factory(:message)
			assert !message.new_record?, "#{message.errors.full_messages.to_sentence}"
		end
	end

	test "should require recipient id" do
		assert_no_difference 'Message.count' do
			message = create_message(:recipient_id => nil)
			assert message.errors.on(:recipient_id)
		end
	end

	test "should require subject" do
		assert_no_difference 'Message.count' do
			message = create_message(:subject => nil)
			assert message.errors.on(:subject)
		end
	end

	test "should require sender" do
		assert_no_difference 'Message.count' do
			message = create_message( {}, false )
			assert message.errors.on(:sender_id)
		end
	end

protected

	def create_message(options = {}, addsender = true )
		options[:sender] = nil unless addsender
		#	gotta build then save so doesn't raise error, just returns false when error
		record = Factory.build(:message, options)
		record.save
		record
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class EmailTest < ActiveSupport::TestCase

	test "should create email" do
		assert_difference 'Email.count' do
			email = create_email
			assert !email.new_record?, "#{email.errors.full_messages.to_sentence}"
		end
	end

	test "should require recipient id" do
		assert_no_difference 'Email.count' do
			email = create_email(:recipient_id => nil)
			assert email.errors.on(:recipient_id)
		end
	end

	test "should require subject" do
		assert_no_difference 'Email.count' do
			email = create_email(:subject => nil)
			assert email.errors.on(:subject)
		end
	end

	test "should require body" do
		assert_no_difference 'Email.count' do
			email = create_email(:body => nil)
			assert email.errors.on(:body)
		end
	end

	test "should require sender" do
		assert_no_difference 'Email.count' do
			email = create_email( {}, false )
			assert email.errors.on(:sender_id)
		end
	end

protected

	def create_email(options = {}, addsender = true )
		options[:sender] = nil unless addsender
		record = Factory.build(:email, options)
		record.save
		record
	end

end

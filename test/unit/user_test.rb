require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
	# Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
	# Then, you can remove it from this and the functional test.
	include AuthenticatedTestHelper

	test "should create user" do
		assert_difference 'User.count' do
			user = create_user
			assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
		end
	end

	test "should initialize activation code upon creation" do
		user = create_user
		user.reload
		assert_not_nil user.activation_code
	end

	test "should require login" do
		assert_no_difference 'User.count' do
			u = create_user(:login => nil)
			assert u.errors.on(:login)
		end
	end

	test "should require login with alphanumeric characters only" do
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123 ")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123-")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123.")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123,")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123<")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123>")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123[")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123]")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123{")
			assert u.errors.on(:login)
		end
		assert_no_difference 'User.count' do
			u = create_user(:login => "abc123}")
			assert u.errors.on(:login)
		end
	end

	test "should require password" do
		assert_no_difference 'User.count' do
			u = create_user(:password => nil)
			assert u.errors.on(:password)
		end
	end

	test "should require password confirmation" do
		assert_no_difference 'User.count' do
			u = create_user(:password_confirmation => nil)
			assert u.errors.on(:password_confirmation)
		end
	end

	test "should require email" do
		assert_no_difference 'User.count' do
			u = create_user(:email => nil)
			assert u.errors.on(:email)
		end
	end

	test "should reset password" do
		user = active_user
		user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
		assert_equal user, User.authenticate(user.login, 'new password')
	end

	test "should not rehash password" do
		user = active_user
		user.update_attributes(:login => 'quentin2')
		assert_equal user, User.authenticate('quentin2', Factory.attributes_for(:user)[:password])
	end

	test "should authenticate user" do
		user = active_user
		assert_equal user, User.authenticate(user.login, Factory.attributes_for(:user)[:password])
	end

	test "should set remember token" do
		user = active_user
		user.remember_me
		assert_not_nil user.remember_token
		assert_not_nil user.remember_token_expires_at
	end

	test "should unset remember token" do
		user = active_user
		user.remember_me
		assert_not_nil user.remember_token
		user.forget_me
		assert_nil user.remember_token
	end

	test "should remember me for one week" do
		user = active_user
		before = 1.week.from_now.utc
		user.remember_me_for 1.week
		after = 1.week.from_now.utc
		assert_not_nil user.remember_token
		assert_not_nil user.remember_token_expires_at
		assert user.remember_token_expires_at.between?(before, after)
	end

	test "should remember me until one week" do
		user = active_user
		time = 1.week.from_now.utc
		user.remember_me_until time
		assert_not_nil user.remember_token
		assert_not_nil user.remember_token_expires_at
		assert_equal user.remember_token_expires_at, time
	end

	test "should remember me default two weeks" do
		user = active_user
		before = 2.weeks.from_now.utc
		user.remember_me
		after = 2.weeks.from_now.utc
		assert_not_nil user.remember_token
		assert_not_nil user.remember_token_expires_at
		assert user.remember_token_expires_at.between?(before, after)
	end

protected

	#
	#	This method is used so that an invalid user produces errors
	#	rather than raises exceptions which will cause the tests to fail.
	#
	def create_user(options = {})
		record = Factory.build(:user,options)
		record.save
		record
	end

end

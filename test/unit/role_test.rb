require File.dirname(__FILE__) + '/../test_helper'

class RoleTest < ActiveSupport::TestCase

	test "should create role" do
		assert_difference 'Role.count' do
			role = create_role
			assert !role.new_record?, "#{role.errors.full_messages.to_sentence}"
		end
		# test uniqueness
		assert_no_difference 'Role.count' do
			role = create_role
			assert role.errors.on(:name)
		end
	end

	test "should require name" do
		assert_no_difference 'Role.count' do
			role = create_role(:name => nil)
			assert role.errors.on(:name)
		end
	end

	test "should require 4 char name" do
		assert_no_difference 'Role.count' do
			role = create_role(:name => 'Hey')
			assert role.errors.on(:name)
		end
	end

protected

	def create_role(options = {})
		record = Role.new({ 
			:name => 'My Role'
		}.merge(options))
		record.save
		record
	end

end

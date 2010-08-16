require File.dirname(__FILE__) + '/../test_helper'

class CreatorTest < ActiveSupport::TestCase

	test "should create creator" do
		assert_difference 'Creator.count' do
			creator = create_creator
			assert !creator.new_record?, "#{creator.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Creator.count' do
			creator = create_creator(:name => nil)
			assert creator.errors.on(:name)
		end
	end

	test "should require name not begin with a bang" do
		assert_no_difference 'Creator.count' do
			creator = create_creator(:name => "!bang")
			assert creator.errors.on(:name)
		end
	end

	test "should require unique name" do
		assert_difference('Creator.count',1) do
			creator = create_creator({:name => "Test Name", :user_id => 1})
			assert !creator.new_record?, "#{creator.errors.full_messages.to_sentence}"
			creator = create_creator({:name => "Test Name", :user_id => 1})
			assert creator.errors.on(:name)
		end
	end

	test "should require user" do
		assert_no_difference 'Creator.count' do
			creator = create_creator( :user => nil )
			assert creator.errors.on(:user_id)
		end
	end

	test "should find or create" do
		assert_difference( 'Creator.count', 1 ) do
			@creator1 = Creator.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert_no_difference( 'Creator.count' ) do
			@creator2 = Creator.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert @creator1 == @creator2
	end

	test "should raise error if multiple named creators" do
		creator1 = create_creator(:name => 'Testing')
		creator2 = create_creator(:name => 'Testing')
		assert_no_difference( 'Creator.count' ) do
			assert_raises(Creator::MultipleCreatorsFound){Creator.find_or_create(:name => 'Testing')}
		end
	end

protected

	def create_creator(options = {})
		record = Factory.build(:creator,options)
		record.save
		record
	end

end

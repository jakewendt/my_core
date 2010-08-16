require File.dirname(__FILE__) + '/../test_helper'

class TagTest < ActiveSupport::TestCase

	test "should create tag" do
		assert_difference 'Tag.count' do
			tag = create_tag
			assert !tag.new_record?, "#{tag.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Tag.count' do
			tag = create_tag(:name => nil)
			assert tag.errors.on(:name)
		end
	end

	test "should require unique name" do
		assert_difference('Tag.count',1) do
			tag = create_tag({:name => "Test Name", :user_id => 1})
			assert !tag.new_record?, "#{tag.errors.full_messages.to_sentence}"
			tag = create_tag({:name => "Test Name", :user_id => 1})
			assert tag.errors.on(:name)
		end
	end

	test "should require user" do
		assert_no_difference 'Tag.count' do
			tag = create_tag( :user => nil )
			assert tag.errors.on(:user_id)
		end
	end

	test "should find or create" do
		assert_difference( 'Tag.count', 1 ) do
			@tag1 = Tag.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert_no_difference( 'Tag.count' ) do
			@tag2 = Tag.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert @tag1 == @tag2
	end

#
#	This isn't really an accurate test as tags require a user_id
#
	test "should raise error if multiple named tags" do
		tag1 = create_tag(:name => 'Testing')
		tag2 = create_tag(:name => 'Testing')
		assert_no_difference( 'Tag.count' ) do
			assert_raises(Tag::MultipleTagsFound){Tag.find_or_create(:name => 'Testing')}
		end
	end

protected

	def create_tag(options = {})
		record = Factory.build(:tag,options)
		record.save
		record
	end

end

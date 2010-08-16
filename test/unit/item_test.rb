require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase

	test "should create item" do
		assert_difference 'Item.count' do
			item = create_item
			assert !item.new_record?, "#{item.errors.full_messages.to_sentence}"
			assert_equal item.user, item.list.user
		end
	end

	test "should clear completed_at on update item when item is complete" do
		assert_difference('Item.count',1) do
			item = create_item
			assert_nil item.reload.completed_at
			assert item.completed == false
			item.update_attribute(:completed,true)
			assert_not_nil item.reload.completed_at
			assert item.completed == true
			item.update_attribute(:completed,false)
			assert_nil item.reload.completed_at
			assert item.completed == false
		end
	end

	test "should NOT require content" do
		assert_difference 'Item.count' do
			item = create_item(:content => nil)
			assert !item.new_record?, "#{item.errors.full_messages.to_sentence}"
		end
	end

	test "should require list" do
		assert_no_difference 'Item.count' do
			item = create_item( {}, false )
			assert item.errors.on(:list_id)
		end
	end

protected

	def create_item(options = {}, addlist = true )
		options[:list] = nil unless addlist
		record = Factory.build(:item,options)
		record.save
		record
	end

end

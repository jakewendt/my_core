require File.dirname(__FILE__) + '/../test_helper'

class ListTest < ActiveSupport::TestCase
	add_taggability_unit_tests "Factory(:list)"
	add_common_search_unit_tests :list

	test "should create list" do
		assert_difference 'List.count' do
			list = create_list
			assert !list.new_record?, "#{list.errors.full_messages.to_sentence}"
		end
	end

	test "should create list and increment all items_count" do
		list = create_list
		list.reload
		assert_equal 0, list.items_count
		assert_equal 0, list.complete_items_count
		assert_equal 0, list.incomplete_items_count
		item1 = Factory(:item, :list => list)
		list.reload
		assert_equal 1, list.items_count
		assert_equal 0, list.complete_items_count
		assert_equal 1, list.incomplete_items_count
		item2 = Factory(:item, :list => list, :completed => true)
		list.reload
		assert_equal 2, list.items_count
		assert_equal 1, list.complete_items_count
		assert_equal 1, list.incomplete_items_count
		item2.update_attribute(:completed, true)
		list.reload
		assert_equal 2, list.items_count
		assert_equal 1, list.complete_items_count
		assert_equal 1, list.incomplete_items_count
		item1.update_attribute(:completed, true)
		list.reload
		assert_equal 2, list.items_count
		assert_equal 2, list.complete_items_count
		assert_equal 0, list.incomplete_items_count
		item2.update_attribute(:completed, false)
		list.reload
		assert_equal 2, list.items_count
		assert_equal 1, list.complete_items_count
		assert_equal 1, list.incomplete_items_count
		item2.destroy
		list.reload
		assert_equal 1, list.items_count
		assert_equal 1, list.complete_items_count
		assert_equal 0, list.incomplete_items_count
	end

	test "should require title" do
		assert_no_difference 'List.count' do
			list = create_list(:title => nil)
			assert list.errors.on(:title)
		end
	end

	test "should require 3 char title" do
		assert_no_difference 'List.count' do
			list = create_list(:title => 'Hi')
			assert list.errors.on(:title)
		end
	end

#	test "should require description" do
#		assert_no_difference 'List.count' do
#			list = create_list(:description => nil)
#			assert list.errors.on(:description)
#		end
#	end

	test "should NOT require a description" do
		assert_difference 'List.count' do
			list = create_list(:description => '')
			assert !list.new_record?, "#{list.errors.full_messages.to_sentence}"
		end
	end

	test "should require user" do
		assert_no_difference 'List.count' do
			list = create_list( {}, false )
			assert list.errors.on(:user_id)
		end
	end

	test "should set list incomplete_items_count on list create" do
		list = list_with_items
		list.reload
		assert_equal 6, list.items_count
		assert_equal 3, list.incomplete_items_count
		assert_equal 3, list.complete_items_count
		assert_equal 6, list.items.count
		assert_equal 3, list.items.incomplete.count
		assert_equal 3, list.items.complete.count
	end

	test "should increment list incomplete_items_count on item create" do
		list = list_with_items
		Factory(:item,:list => list)
		list.reload
		assert_equal 7, list.items_count
		assert_equal 4, list.incomplete_items_count
		assert_equal 3, list.complete_items_count
		assert_equal 7, list.items.count
		assert_equal 4, list.items.incomplete.count
		assert_equal 3, list.items.complete.count
	end

	test "should increment list complete_items_count on item completion" do
		list = list_with_items
		list.items.first.update_attribute(:completed, true)
		list.reload
		assert_equal 6, list.items_count
		assert_equal 2, list.incomplete_items_count
		assert_equal 4, list.complete_items_count
		assert_equal 6, list.items.count
		assert_equal 2, list.items.incomplete.count
		assert_equal 4, list.items.complete.count
	end

	test "should increment list incomplete_items_count on item incompletion" do
		list = list_with_items(3,:completed => true)
		list.items.first.update_attribute(:completed, false)
		list.reload
		assert_equal 6, list.items_count
		assert_equal 1, list.incomplete_items_count
		assert_equal 5, list.complete_items_count
		assert_equal 6, list.items.count
		assert_equal 1, list.items.incomplete.count
		assert_equal 5, list.items.complete.count
	end

	test "should decrement list incomplete_items_count on item destroy" do
		list = list_with_items(3,:completed => false)
		list.items.first.destroy
		list.reload
		assert_equal 5, list.items_count
		assert_equal 5, list.incomplete_items_count
		assert_equal 0, list.complete_items_count
		assert_equal 5, list.items.count
		assert_equal 5, list.items.incomplete.count
		assert_equal 0, list.items.complete.count
	end

	test "should decrement list complete_items_count on item destroy" do
		list = list_with_items(3,:completed => true)
		list.items.first.destroy
		list.reload
		assert_equal 5, list.items_count
		assert_equal 0, list.incomplete_items_count
		assert_equal 5, list.complete_items_count
		assert_equal 5, list.items.count
		assert_equal 0, list.items.incomplete.count
		assert_equal 5, list.items.complete.count
	end

	test "should update list updated_at on item create" do
		list = list_with_items
		before = list.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		Factory(:item, :list => list)
		after = list.reload.updated_at
		assert_not_equal before, after
	end

	test "should update list updated_at on item update" do
		list = list_with_items
		before = list.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		list.items.first.update_attribute(:content, "New item content")
		after = list.reload.updated_at
		assert_not_equal before, after
	end

	test "should update list updated_at on item destroy" do
		list = list_with_items
		before = list.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		list.items.first.destroy
		after = list.reload.updated_at
		assert_not_equal before, after
	end

	test "should update list updated_at on item update through nested item attributes" do
		list = list_with_items
		before = list.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		list.update_attribute(:incomplete_items_attributes, [{
			:id => list.incomplete_items.first.id,
			:content => "UPDATED " + list.incomplete_items.first.content
		}])
		after = list.reload.updated_at
		assert_not_equal before, after
	end

	test "should update list updated_at on item destroy nested item attributes" do
		list = list_with_items
		before = list.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		assert_difference( "List.find(#{list.id}).incomplete_items.length", -1 ) do
			list.update_attribute(:incomplete_items_attributes, [{
				:id => list.incomplete_items.first.id,
				:_destroy => true
#				:_delete => true
			}])
		end
		after = list.reload.updated_at
		assert_not_equal before, after
	end

	test "should update list and items" do
		list = list_with_items
		items = []
		list.incomplete_items.each do |item|
			items.push( { :id => item.id, :content => "UPDATED " + item.content } )
		end
		list.update_attributes( { :incomplete_items_attributes => items } )
		list.reload.incomplete_items.each do |item|
			assert_not_nil item.content.match(/^UPDATED /)
		end
	end

	test "should delete item on list update" do
		list = list_with_items
		item = list.incomplete_items.first
#		items = [{:id => item.id, :_delete => true }]
		items = [{:id => item.id, :_destroy => true }]
		assert_difference( "List.find(#{list.id}).incomplete_items.length", -1 ) do
			list.update_attributes( { :incomplete_items_attributes => items } )
		end
	end


protected

	def create_list(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:list,options)
		record.save
		record
	end

end

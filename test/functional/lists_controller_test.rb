require File.dirname(__FILE__) + '/../test_helper'
require 'hash_extension'

class ListsControllerTest < ActionController::TestCase

	add_core_tests( :list, :except => [:update_js] )
	add_common_search_tests( :list )
	add_pdf_downloadability_tests 'list_with_items'
	add_txt_downloadability_tests 'list_with_items'

	# override because redirects to show and not edit
	def test_should_create_with_login
		user = active_user
		login_as user
		assert_difference('List.count', 1) { create }
		assert_equal assigns(:list).user, user
		assert_redirected_to list_path(assigns(:list))
	end 

	test "should update list and items with owner login" do
		list = list_with_items
		initial_updated_at = list.updated_at
		login_as list.user
		items = []
		list.incomplete_items.each do |item|
			items.push( { :id => item.id, :content => "UPDATED " + item.content } )
		end
		put :update, :id => list.id, :list => { :incomplete_items_attributes => items }

		list.reload.incomplete_items.each do |item|
			assert_not_nil item.content.match(/^UPDATED /)
		end
		assert_redirected_to assigns(:list)
		assert_not_equal assigns(:list).updated_at, initial_updated_at
	end

	test "should destroy item on list update with owner login" do
		list = list_with_items
		initial_updated_at = list.updated_at
		login_as list.user
#		items = [{:id => list.items.first.id, :_delete => true }]
		items = [{:id => list.items.first.id, :_destroy => true }]
		assert_difference("List.find(#{list.id}).items.length", -1) do
			put :update, :id => list.id, :list => { :incomplete_items_attributes => items }
		end
		assert_redirected_to assigns(:list)
		assert_not_equal assigns(:list).updated_at, initial_updated_at
	end

#	List.copy tests

	test "should NOT copy list without owner login" do
		list = list_with_items
		login_as active_user
		assert_no_difference('List.count') do
			get :copy, :id => list.id
		end
		assert_equal assigns(:list),list
		assert_redirected_to root_path
	end

	test "should NOT copy list when save fails" do
		list = list_with_items
		List.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(List.new))
		login_as list.user
		assert_no_difference('List.count') do
			get :copy, :id => list.id
		end
		assert_equal assigns(:list), list
		assert_response :success
		assert_template 'show'
		assert_not_nil flash[:error]
	end

	test "should copy list with owner login" do
		list = list_with_items
		login_as list.user
		assert_difference('List.count',1) do
			get :copy, :id => list.id
		end
		assert_not_equal assigns(:list), list
		list.reload           # reload to get the proper *items_count
		assigns(:list).reload # reload to get the proper *items_count
#puts list.items_count
#puts list.incomplete_items_count
#puts list.complete_items_count
		assert_equal list.attributes.delete_keys!('id','updated_at','created_at'),
			assigns(:list).attributes.delete_keys!('id','updated_at','created_at')
#	sometimes, completed_at is off by 1 second 
		assert_equal list.items.map{|i| i.attributes.delete_keys!('list_id','id','updated_at','created_at','completed_at') },
			assigns(:list).items.map{|i| i.attributes.delete_keys!('list_id','id','updated_at','created_at','completed_at') }
		assert_redirected_to edit_list_path(assigns(:list))
	end

#	List.convert_to_note tests

	test "should NOT convert list to note without owner login" do
		list = list_with_items
		login_as active_user
		assert_no_difference('Note.count') do
			get :convert_to_note, :id => list.id
		end
		assert_equal list, assigns(:list)
		assert_redirected_to root_path
	end

	test "should NOT convert list to note when save fails" do
		list = list_with_items
		Note.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(Note.new))
		login_as list.user
		assert_no_difference('Note.count') do
			get :convert_to_note, :id => list.id
		end
		assert_equal assigns(:list), list
		assert_response :success
		assert_template 'show'
		assert_not_nil flash[:error]
	end

	test "should convert list to note with owner login" do
		list = list_with_items
		login_as list.user
		assert_difference('Note.count',1) do
			get :convert_to_note, :id => list.id
		end
		assert_equal list.title, assigns(:note).title
		assert assigns(:note).body.include?("Incomplete")
		assert_redirected_to edit_note_path(assigns(:note))
	end

	test "should NOT mark all complete without login" do
		list = list_with_items
		assert_no_difference("List.find(#{list.id}).items.complete.size") do
			get :mark_all_complete, :id => list.id
		end
		assert_redirected_to login_path
	end

	test "should NOT mark all complete without owner login" do
		list = list_with_items
		login_as active_user
		assert_no_difference("List.find(#{list.id}).items.complete.size") do
			get :mark_all_complete, :id => list.id
		end
		assert_redirected_to root_path
	end

	test "should mark all complete with owner login" do
		list = list_with_items
		login_as list.user
		assert_difference("List.find(#{list.id}).items.complete.size",3) do
			get :mark_all_complete, :id => list.id
		end
		assert_redirected_to assigns(:list)
	end

	test "should mark all complete with admin login" do
		list = list_with_items
		login_as admin_user
		assert_difference("List.find(#{list.id}).items.complete.size",3) do
			get :mark_all_complete, :id => list.id
		end
		assert_redirected_to assigns(:list)
	end


	test "should NOT mark all incomplete without login" do
		list = list_with_items
		assert_no_difference("List.find(#{list.id}).items.incomplete.size") do
			get :mark_all_incomplete, :id => list.id
		end
		assert_redirected_to login_path
	end

	test "should NOT mark all incomplete without owner login" do
		list = list_with_items
		login_as active_user
		assert_no_difference("List.find(#{list.id}).items.incomplete.size") do
			get :mark_all_incomplete, :id => list.id
		end
		assert_redirected_to root_path
	end

	test "should mark all incomplete with owner login" do
		list = list_with_items
		login_as list.user
		assert_difference("List.find(#{list.id}).items.incomplete.size",3) do
			get :mark_all_incomplete, :id => list.id
		end
		assert_redirected_to assigns(:list)
	end

	test "should mark all incomplete with admin login" do
		list = list_with_items
		login_as admin_user
		assert_difference("List.find(#{list.id}).items.incomplete.size",3) do
			get :mark_all_incomplete, :id => list.id
		end
		assert_redirected_to assigns(:list)
	end



	def create(options={})
		post :create, { 
			:list => Factory.attributes_for(:list)
		}.merge(options)
	end

end

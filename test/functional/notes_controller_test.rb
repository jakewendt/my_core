require File.dirname(__FILE__) + '/../test_helper'
require 'hash_extension'

class NotesControllerTest < ActionController::TestCase

	add_core_tests( :note, { :except => [ :update_js ] } )
	add_common_search_tests( :note )
	add_pdf_downloadability_tests 'Factory(:public_note)'
	add_txt_downloadability_tests 'Factory(:public_note)'

	# override because redirects to show and not edit
	#	because the method already exists, test "" do won't work
	def test_should_create_with_login
		user = active_user
		login_as user
		assert_difference('Note.count', 1) { create }
		assert_equal assigns(:note).user, user
		assert_redirected_to note_path(assigns(:note))
	end

#	Note.copy tests

	test "should NOT copy note without owner login" do
		note = Factory(:note)
		login_as active_user
		assert_no_difference('Note.count') do
			get :copy, :id => note.id
		end
		assert_equal assigns(:note),note
		assert_redirected_to root_path
	end

	test "should NOT copy note when create fails" do
		note = Factory(:note)
		Note.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(Note.new))
		login_as note.user
		assert_no_difference('Note.count') do
			get :copy, :id => note.id
		end
		assert_equal assigns(:note), note
		assert_response :success
		assert_template 'show'
		assert_not_nil flash[:error]
	end

	test "should copy note with owner login" do
		note = Factory(:note)
		login_as note.user
		assert_difference('Note.count',1) do
			get :copy, :id => note.id
		end
		assert_not_equal assigns(:note), note
		assert_equal assigns(:note).attributes.delete_keys!('id','updated_at','created_at'),
			note.attributes.delete_keys!('id','updated_at','created_at')
		assert_redirected_to edit_note_path(assigns(:note))
	end

#	Note.convert_to_list

	test "should NOT convert note to list without owner login" do
		note = Factory(:note)
		login_as active_user
		assert_no_difference('List.count') do
			get :convert_to_list, :id => note.id
		end
		assert_equal note, assigns(:note)
		assert_redirected_to root_path
	end

	test "should NOT convert note to list when save fails" do
		note = Factory(:note)
		List.any_instance.stubs(:save!).raises(ActiveRecord::RecordInvalid.new(List.new))
		login_as note.user
		assert_no_difference('List.count') do
			get :convert_to_list, :id => note.id
		end
		assert_nil assigns(:list)
		assert_equal assigns(:note), note
		assert_response :success
		assert_template 'show'
		assert_not_nil flash[:error]
	end

	test "should convert note to list with owner login" do
		note = Factory(:note)
		login_as note.user
		assert_difference('List.count',1) do
			get :convert_to_list, :id => note.id
		end
		assert_equal note.title, assigns(:list).title
		assert assigns(:list).description.blank?
		assert_redirected_to edit_list_path(assigns(:list))
	end

	def create(options={})
		post :create, { 
			:note => Factory.attributes_for(:note)
		}.merge(options)
	end

end

require File.dirname(__FILE__) + '/../test_helper'

class EntriesControllerTest < ActionController::TestCase
	add_core_tests :entry, :only => [ :confirm_destroy ]
	add_commentability_tests
	add_photoability_tests

	test "should NOT have index route" do
		assert_raise(ActionController::RoutingError){ get :index, :blog_id => 1 }
	end

	test "should NOT get new without login" do
		entry = Factory(:public_entry)
		get :new, :blog_id => entry.blog.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get new without owner login" do
		entry = Factory(:public_entry)
		login_as active_user
		get :new, :blog_id => entry.blog.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get new with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		get :new, :blog_id => entry.blog.id
		assert_response :success
		assert_template 'new'
	end

	test "should get new with admin login" do
		entry = Factory(:public_entry)
		login_as admin_user
		get :new, :blog_id => entry.blog.id
		assert_response :success
		assert_template 'new'
	end


	test "should NOT create entry without login" do
		entry = Factory(:public_entry)
		assert_no_difference('Entry.count') do
			post :create, :blog_id => entry.blog.id, :entry => Factory.attributes_for(:entry)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create entry without owner login" do
		entry = Factory(:public_entry)
		login_as active_user
		assert_no_difference('Entry.count') do
			post :create, :blog_id => entry.blog.id, :entry => Factory.attributes_for(:entry)
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should create entry with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		assert_difference('Entry.count') do
			post :create, :blog_id => entry.blog.id, :entry => Factory.attributes_for(:entry)
		end
		assert_redirected_to blog_path(assigns(:blog))
	end

	test "should create entry with admin login" do
		entry = Factory(:public_entry)
		login_as admin_user
		assert_difference('Entry.count') do
			post :create, :blog_id => entry.blog.id, :entry => Factory.attributes_for(:entry)
		end
		assert_redirected_to blog_path(assigns(:blog))
	end

	test "should NOT create invalid entry" do
		entry = Factory(:public_entry)
		login_as admin_user
		assert_no_difference('Entry.count') do
			post :create, :blog_id => entry.blog.id, :entry => Factory.attributes_for(:entry).merge(:title => 'a')
		end
		assert_response :success
		assert_not_nil flash[:error]
		assert_template 'new'
	end


	test "should show entry without login" do
		entry = Factory(:public_entry)
		get :show, :id => entry.id
		assert_response :success
		assert_template 'show'
		assert_select 'title', entry.title
	end

	test "should show entry with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		get :show, :id => entry.id
		assert_response :success
		assert_template 'show'
		assert_select 'title', entry.title
	end


	test "should NOT get edit without login" do
		entry = Factory(:public_entry)
		get :edit, :id => entry.id
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without owner login" do
		entry = Factory(:public_entry)
		login_as active_user
		get :edit, :id => entry.id
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should get edit with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		get :edit, :id => entry.id
		assert_response :success
		assert_template 'edit'
	end

	test "should get edit with admin login" do
		entry = Factory(:public_entry)
		login_as admin_user
		get :edit, :id => entry.id
		assert_response :success
		assert_template 'edit'
	end


	test "should NOT update entry without login" do
		entry = Factory(:public_entry)
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update entry without owner login" do
		entry = Factory(:public_entry)
		login_as active_user
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should update entry with owner login and photos" do
		entry = entry_with_photos(Factory(:blog))
		photos = {}
		entry.photos.each do |photo|
			photos[photo.id.to_s] = { 'caption' => 'New Caption' }
		end
		login_as entry.user
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry),
			:photo => photos
		assert_not_nil assigns(:blog)
		assert_redirected_to entry_path(assigns(:entry))
		entry.photos.destroy_all	#	ensure that the files get removed
	end

	test "should update entry with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry)
		assert_not_nil assigns(:blog)
		assert_redirected_to entry_path(assigns(:entry))
	end

	test "should update entry with admin login" do
		entry = Factory(:public_entry)
		login_as admin_user
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry)
		assert_not_nil assigns(:blog)
		assert_redirected_to entry_path(assigns(:entry))
	end

	test "should NOT update invalid entry" do
		entry = Factory(:public_entry)
		login_as admin_user
		put :update, :id => entry.id, :entry => Factory.attributes_for(:entry).merge(:title => 'a')
		assert_not_nil flash[:error]
		assert_response :success
		assert_template 'edit'
	end


	test "should NOT destroy entry without login" do
		entry = Factory(:public_entry)
		assert_no_difference('Entry.count') do
			delete :destroy, :id => entry.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy entry without owner login" do
		entry = Factory(:public_entry)
		login_as active_user
		assert_no_difference('Entry.count') do
			delete :destroy, :id => entry.id
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy entry with owner login" do
		entry = Factory(:public_entry)
		login_as entry.user
		assert_difference('Entry.count', -1) do
			delete :destroy, :id => entry.id
		end
		assert_redirected_to blog_path(assigns(:blog))
	end

	test "should destroy entry with admin login" do
		entry = Factory(:public_entry)
		login_as admin_user
		assert_difference('Entry.count', -1) do
			delete :destroy, :id => entry.id
		end
		assert_redirected_to blog_path(assigns(:blog))
	end

end

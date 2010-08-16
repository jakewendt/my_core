require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase

	test "should get index with admin login" do
		login_as admin_user
		get :index
		assert_template 'index'
		assert_response :success
		assert_not_nil assigns(:pages)
	end

	test "should NOT get index without login" do
		get :index
#		assert_template 'index'
#		assert_response :success
#		assert_not_nil assigns(:pages)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end


	test "should get new with admin login" do
		login_as admin_user
		get :new
		assert_template 'new'
		assert_response :success
	end

	test "should NOT get new without login" do
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get new without admin login" do
		login_as active_user
		get :new
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	test "should create page with admin login" do
		login_as admin_user
		assert_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_redirected_to page_path(assigns(:page))
	end

	test "should NOT create page with invalid page" do
		login_as admin_user
		assert_no_difference('Page.count') do
			post :create, :page => {}
		end
		assert_template 'new'
		assert_response :success
	end

	test "should NOT create page without login" do
		assert_no_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT create page without admin login" do
		login_as active_user
		assert_no_difference('Page.count') do
			post :create, :page => Factory.attributes_for(:page)
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end


	test "should NOT show page with invalid id" do
		get :show, :id => 0
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should show page without login" do
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page with login" do
		login_as active_user
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page with admin login" do		#	test admin so that the css page_menu gets tested
		login_as admin_user
		page = Factory(:page)
		get :show, :id => page.id
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page by position" do
		page = Factory(:page)
		get :show_position, :id => 1
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should NOT show page without matching path or title" do
		get :show, :path => "/i/do/not/exist".split('/').delete_if{|x|x.blank?}
		assert_not_nil flash[:error]
		assert_template 'show'
		assert_response :success
	end

	test "should show page by path title" do
		page = Factory(:page, :path => 'valid', :title => '/thispage')
		get :show, :path => page.title.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page by path" do
		page = Factory(:page)
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should show page by path with slashes" do
		page = Factory(:page, :path => "/help/blogs")
		get :show, :path => page.path.split('/').delete_if{|x|x.blank?}
		assert_equal assigns(:page), page
		assert_template 'show'
		assert_response :success
		assert_select 'title', page.title
	end

	test "should get edit with admin login" do
		login_as admin_user
		get :edit, :id => Factory(:page)
		assert_template 'edit'
		assert_response :success
	end

	test "should NOT get edit without login" do
		login_as nil
		get :edit, :id => Factory(:page)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT get edit without admin login" do
		login_as active_user
		get :edit, :id => Factory(:page)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should update page with admin login" do
		login_as admin_user
		put :update, :id => Factory(:page), :page => Factory.attributes_for(:page)
		assert_redirected_to page_path(assigns(:page))
	end

	test "should NOT update page with invalid page" do
		login_as admin_user
		put :update, :id => Factory(:page), :page => { :title => "a" }
		assert_not_nil flash[:error]
		assert_template 'edit'
		assert_response :success
	end

	test "should NOT update page without login" do
		put :update, :id => Factory(:page), :page => Factory.attributes_for(:page)
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT update page without admin login" do
		login_as active_user
		put :update, :id => Factory(:page), :page => Factory.attributes_for(:page)
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should destroy page with admin login" do
		login_as admin_user
		page = Factory(:page)
		assert_difference('Page.count', -1) do
			delete :destroy, :id => page
		end
		assert_redirected_to pages_path
	end

	test "should NOT destroy page without login" do
		login_as nil
		page = Factory(:page)
		assert_no_difference('Page.count') do
			delete :destroy, :id => page
		end
		assert_not_nil flash[:error]
		assert_redirected_to login_path
	end

	test "should NOT destroy page without admin login" do
		login_as active_user
		page = Factory(:page)
		assert_no_difference('Page.count') do
			delete :destroy, :id => page
		end
		assert_not_nil flash[:error]
		assert_redirected_to root_path
	end

	test "should move page lower with admin login" do
		login_as admin_user
		page1 = Factory(:page)
		page2 = Factory(:page)
		pages = Page.find(:all, :order => :position)
		assert_equal pages, [page1,page2]
		put :move_lower, :id => page1
		pages = Page.find(:all, :order => :position)
		assert_equal pages, [page2,page1]
		assert_redirected_to pages_path
	end

	test "should move page higher with admin login" do
		login_as admin_user
		page1 = Factory(:page)
		page2 = Factory(:page)
		pages = Page.find(:all, :order => :position)
		assert_equal pages, [page1,page2]
		put :move_higher, :id => page2
		pages = Page.find(:all, :order => :position)
		assert_equal pages, [page2,page1]
		assert_redirected_to pages_path
	end

	test "should get index with both help and non-help pages" do
		#	test css menus
		login_as admin_user
		nonhelp_page = Factory(:page, :path => "/hello" )
		help_page = Factory(:page, :path => "/help/test" )
		get :index
		assert_response :success
		assert_template 'index'
	end

end

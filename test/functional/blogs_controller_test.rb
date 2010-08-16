require File.dirname(__FILE__) + '/../test_helper'

class BlogsControllerTest < ActionController::TestCase

	add_core_tests( :blog, { :except => [ :update_js ] } )
	add_common_search_tests( :blog )
	add_rss_feed_tests 'blog_with_entries'
	add_pdf_downloadability_tests 'blog_with_entries_with_photos_and_comments'
	add_txt_downloadability_tests 'blog_with_entries'

	# override due to different redirect
	#	cannot be test "" do style
	def test_should_create_with_login
		user = active_user
		login_as user
		assert_difference('Blog.count', 1) { create }
		assert_equal assigns(:blog).user, user
		assert_redirected_to blog_path(assigns(:blog))
	end

	def create(options={})
		post :create, { 
			:blog => Factory.attributes_for(:blog)
		}.merge(options)
	end

end

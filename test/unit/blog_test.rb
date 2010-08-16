require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
	add_taggability_unit_tests "Factory(:blog)"
	add_common_search_unit_tests :blog

	test "should create blog" do
		assert_difference 'Blog.count' do
			blog = create_blog
			assert !blog.new_record?, "#{blog.errors.full_messages.to_sentence}"
		end
	end

	test "should require title" do
		assert_no_difference 'Blog.count' do
			blog = create_blog(:title => nil)
			assert blog.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Blog.count' do
			blog = create_blog(:title => 'Hey')
			assert blog.errors.on(:title)
		end
	end

	test "should create blog without description" do
		assert_difference 'Blog.count' do
			blog = create_blog(:description => nil)
			assert !blog.new_record?, "#{blog.errors.full_messages.to_sentence}"
		end
	end

	test "should require user" do
		assert_no_difference 'Blog.count' do
			blog = create_blog( {}, false )
			assert blog.errors.on(:user_id)
		end
	end

protected

	def create_blog(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:blog, options)
		record.save
		record
	end

end

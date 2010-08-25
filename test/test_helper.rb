ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

$LOAD_PATH.unshift File.dirname(__FILE__)	#	NEEDED for rake test:coverage
require 'authenticated_test_helper'
require 'factory_test_helper'
require 'core_test'
require 'common_search_test'
require 'orderable_test'
require 'commentable_test'
require 'photoable_test'
require 'rss_feed_test'
require 'pdf_downloadable_test'
require 'txt_downloadable_test'
require 'taggability_test'

include AuthenticatedTestHelper
include FactoryTestHelper

class ActiveSupport::TestCase

	self.use_transactional_fixtures = true
	self.use_instantiated_fixtures	= false
	fixtures :all





	# From module Topfunky::TestHelper
	#
	##
	# A simple method for setting the Accept header in a test.
	#
	# Useful for REST controllers that use ++respond_to++ to serve different types of content.
	#
	# Options for ++type_symbol++ are :xml, :js, or :html.
	#
	#	def test_index_should_serve_js
	#		wants :js
	#		get :index
	#		assert_match 'alert', @response.body
	#	end
	#

	def wants(type_symbol)
		@request.accept = case type_symbol
											when :js
												"text/javascript"
											when :xml
												'text/xml'
											when :html
												'text/html'
											when :txt
												'application/txt'
											when :pdf
												'application/pdf'
											when :rss
												'application/rss+xml'
											end
	end

	#       from vendor/plugins/file_column/test/abstract_unit.rb
	def file_path(filename)
		File.expand_path("#{File.dirname(__FILE__)}/fixtures/#{filename}")
	end
	alias_method :f, :file_path

end

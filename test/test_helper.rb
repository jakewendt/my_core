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

#require File.dirname(__FILE__) + '/../vendor/plugins/file_column/lib/test_case.rb'

include AuthenticatedTestHelper
include FactoryTestHelper

#	assert-valid-asset plugin (does not seem to be Rails 2.3.2 compatible)
#class ActionController::TestCase
#	self.auto_validate = true
#	self.display_invalid_content = true
#end



#	update html_test plugin
#	install my html_test_extension plugin
#	remove some of the excess here



#	html_test plugin
ApplicationController.validate_all = true
#	default is :tidy, but it doesn't really validate.	
#	I've purposely not closed tags and it doesn't complain.
#	:w3c is ridiculously slow! even when used locally
ApplicationController.validators = [:w3c]
#ApplicationController.validators = [:tidy, :w3c]

Html::Test::Validator.verbose = false
#	http://habilis.net/validator-sac/
#	http://habilis.net/validator-sac/#advancedtopics
Html::Test::Validator.w3c_url = "http://localhost/w3c-validator/check"
Html::Test::Validator.tidy_ignore_list = [/<table> lacks "summary" attribute/]

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

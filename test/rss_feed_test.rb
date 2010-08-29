module RssFeedTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		def add_rss_feed_tests( factory_function )

			test "should show public rss without login" do
				obj = eval(factory_function)
#				wants :rss
				get :show, :id => obj.id, :format => 'rss'
				assert_not_nil assigns(obj.class.name.downcase.to_sym)
				assert_response :success
				assert_template 'show'
				assert @response.headers['Content-Type'] == "application/rss+xml; charset=utf-8"
				assert @response.body.include?("<?xml ")
				assert @response.body.include?("<rss ")

#<?xml version="1.0" encoding="UTF-8"?>
#<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">
#  <channel>
			end

		end
	end
end
#Test::Unit::TestCase.send(:include,RssFeedTest)
ActiveSupport::TestCase.send(:include,RssFeedTest)

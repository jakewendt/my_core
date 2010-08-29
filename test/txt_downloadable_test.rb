module TxtDownloadableTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		def add_txt_downloadability_tests( factory_function, actions = %w(show show_public index) )

			test "should show txt with login" do
				obj = eval(factory_function)
				login_as obj.user
#				wants :txt
				get :show, :id => obj.id, :format => 'txt'
				assert_not_nil assigns(obj.class.name.downcase.to_sym)
				assert_response :success
				assert_template 'show'
				#	attachment; filename=blog_127_20090820145806.txt
				assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*txt/)
			end if actions.include?('show')

			test "should show public txt without login" do
				obj = eval(factory_function)
#				wants :txt
				get :show, :id => obj.id, :format => 'txt'
				assert_not_nil assigns(obj.class.name.downcase.to_sym)
				assert_response :success
				assert_template 'show'
				#	attachment; filename=blog_127_20090820145806.txt
				assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*txt/)
			end if actions.include?('show_public')

			test "should get index txt with login" do
				obj = eval(factory_function)
				login_as obj.user
#				wants :txt
				get :index, :format => 'txt'
				assert_not_nil assigns(obj.class.name.downcase.pluralize.to_sym)
				assert_response :success
				assert_template 'index'
				#	attachment; filename=blogs_20090820150314.txt
				assert_not_nil @response.headers['Content-disposition'].match(/attachment;.*txt/)
			end if actions.include?('index')

		end
	end
end
#Test::Unit::TestCase.send(:include,TxtDownloadableTest)
ActiveSupport::TestCase.send(:include,TxtDownloadableTest)

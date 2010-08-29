module TaggabilityTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods

		def add_taggability_unit_tests( factory_function )

			test "should create with tags without duplicates" do
				arclass = self.class.name.sub(/Test$/,'')
				assert_difference("#{arclass}.count",1) {
				assert_difference('Tag.count',2) {
				assert_difference('Tagging.count',2) {
					obj = eval(factory_function)
					obj.tag_names = "me,you,me,you"
					obj.save
					assert !obj.new_record?, "#{obj.errors.full_messages.to_sentence}"
				} } }
			end 

		end

		def add_taggability_functional_tests( factory_function )	#, actions = %w(show index) )

#			test "should show public pdf without login" do
#				obj = eval(factory_function)
#				wants :pdf
#				get :show, :id => obj.id
#				assert_not_nil assigns(obj.class.name.downcase.to_sym)
#				assert_response :success
#				assert_template 'show'
#				assert @response.body.include?("Creator (Prawn)")
#				assert_not_nil @response.headers['Content-disposition'].match(/inline;.*pdf/)
#			end if actions.include?('show')
#
#			test "should get index pdf with login" do
#				obj = eval(factory_function)
#				login_as obj.user
#				wants :pdf
#				get :index
#				assert_not_nil assigns(obj.class.name.downcase.pluralize.to_sym)
#				assert_response :success
#				assert_template 'index'
#				assert @response.body.include?("Creator (Prawn)")
#				assert_not_nil @response.headers['Content-disposition'].match(/inline;.*pdf/)
#			end if actions.include?('show')

		end
	end
end
#Test::Unit::TestCase.send(:include,TaggabilityTest)
ActiveSupport::TestCase.send(:include,TaggabilityTest)

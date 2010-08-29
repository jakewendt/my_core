#require 'array_extension'
module OrderableTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		#	 add_orderability_tests :list, :items
		#	 add_orderability_tests :trip, :stops, true	# because list is inverted
		def add_orderability_tests(belongs_to_name, has_many_name, flip=false)

			test "order" do
				to_order       = has_many_name.to_s
				belongs_to_id	 = belongs_to_name.to_s+"_id"
				belongs_to_obj = Factory(belongs_to_name)
				login_as belongs_to_obj.user
				(1..4).each do |counter|
					me = Factory(to_order.singularize, belongs_to_name => belongs_to_obj)
				end
				original_ids = belongs_to_obj.send(to_order).map(&:id)

				rearranged_ids = original_ids.arrange([1,2,3,0])
				put :order, belongs_to_id.to_sym => belongs_to_obj.id,
					to_order.to_sym => rearranged_ids
				result = rearranged_ids
				result.reverse! if flip
				assert_equal result, belongs_to_obj.send(to_order).reload.map(&:id)

				rearranged_ids = original_ids.arrange([3,2,1,0])
				put :order, belongs_to_id.to_sym => belongs_to_obj.id,
					to_order.to_sym => rearranged_ids
				result = rearranged_ids
				result.reverse! if flip
				assert_equal result, belongs_to_obj.send(to_order).reload.map(&:id)
			end

		end
	end
end
#Test::Unit::TestCase.send(:include,OrderableTest)
ActiveSupport::TestCase.send(:include,OrderableTest)

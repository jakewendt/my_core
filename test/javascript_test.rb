#module JavascriptTest
#ActionController::Base.class_eval do
ActionController::Base
class ActionController::Base
puts "TESTING"
	after_filter :check_for_javascript

private

	def check_for_javascript
puts "in check_for_javascript"
#		assert !@response.body.match(/(onclick)/)
#flunk
	end
end
#ActionController::Base.send(:include,JavascriptTest)

require 'resume_component'
ActiveRecord::Base.send( :include, ResumeComponent )
require 'resume_component_controller'
ActionController::Base.send(:include,ResumeComponentController)
if RAILS_ENV == 'test'
	#	TestCase doesn't seem to be loaded yet so do it manually
	require 'test/unit/testcase'
	require 'resume_component_test' 
	Test::Unit::TestCase.send(:include,ResumeComponentTest)
end

require File.dirname(__FILE__) + '/../test_helper'

class LanguagesControllerTest < ActionController::TestCase

	add_orderability_tests :resume, :languages
	add_resume_component_functional_tests :language

end

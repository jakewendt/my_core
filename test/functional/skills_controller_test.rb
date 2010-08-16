require File.dirname(__FILE__) + '/../test_helper'

class SkillsControllerTest < ActionController::TestCase

	add_orderability_tests :resume, :skills
	add_resume_component_functional_tests :skill

end

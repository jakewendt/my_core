require File.dirname(__FILE__) + '/../test_helper'

class ResumesControllerTest < ActionController::TestCase

	add_core_tests( :resume, :except => [:update_js] )
	add_common_search_tests( :resume )
	add_pdf_downloadability_tests 'resume_with_components'
	add_txt_downloadability_tests 'resume_with_components'

	%w( affiliation job language publication school skill ).each do |component|
		test "should update #{component} with resume update and owner login" do
			resume = resume_with_components
			login_as resume.user
			
			comps = []
			resume.send(component.pluralize).each do |comp|
				comps.push({ :id => comp.id, comp.default_field => 'UPDATED ' + comp.default })
			end
			put :update, :id => resume.id, :resume => {
				"#{component.pluralize}_attributes" => comps
			}
			resume.reload.send(component.pluralize).each do |comp|
				assert_not_nil comp.default.match(/^UPDATED /)
			end
			assert_redirected_to resume
		end

		test "should delete #{component} on resume update" do
			resume = resume_with_components
			login_as resume.user
			comp  = resume.send(component.pluralize).first
			comps = [{:id => comp.id, :_delete => true }]
			assert_difference( "Resume.find(#{resume.id}).send('#{component.pluralize}').length", -1 ) do
				put :update, :id => resume.id, :resume => {
					"#{component.pluralize}_attributes" => comps
				}
			end
		end

	end

end

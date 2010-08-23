require File.dirname(__FILE__) + '/../test_helper'

class ResumeTest < ActiveSupport::TestCase
	add_common_search_unit_tests :resume

	test "should create resume" do
		assert_difference 'Resume.count' do
			resume = create_resume
			assert !resume.new_record?, "#{resume.errors.full_messages.to_sentence}"
		end
	end

	test "should require title" do
		assert_no_difference 'Resume.count' do
			resume = create_resume(:title => nil)
			assert resume.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Resume.count' do
			resume = create_resume(:title => 'Hey')
			assert resume.errors.on(:title)
		end
	end

	test "should require user" do
		assert_no_difference 'Resume.count' do
			resume = create_resume( {}, false )
			assert resume.errors.on(:user_id)
		end
	end

#	test "should update resume and components" do
#		resume = resume_with_components
#		skills = []
#		jobs = []
#		schools = []
#		publications = []
#		affiliations = []
#		languages = []
#		resume.skills.each do |skill|
#			skills.push( { :id => skill.id, :name => "UPDATED " + skill.name } )
#		end
#		resume.jobs.each do |job|
#			jobs.push( { :id => job.id, :title => "UPDATED " + job.title } )
#		end
#		resume.schools.each do |school|
#			schools.push( { :id => school.id, :name => "UPDATED " + school.name } )
#		end
#		resume.publications.each do |publication|
#			publications.push( { :id => publication.id, :name => "UPDATED " + publication.name } )
#		end
#		resume.affiliations.each do |affiliation|
#			affiliations.push( { :id => affiliation.id, :organization => "UPDATED " + affiliation.organization } )
#		end
#		resume.languages.each do |language|
#			languages.push( { :id => language.id, :name => "UPDATED " + language.name } )
#		end
#		resume.update_attributes( { 
#			:skills_attributes => skills,
#			:jobs_attributes => jobs,
#			:schools_attributes => schools,
#			:publications_attributes => publications,
#			:affiliations_attributes => affiliations,
#			:languages_attributes => languages
#		} )
#		resume.reload.skills.each do |skill|
#			assert_not_nil skill.name.match(/^UPDATED /)
#		end
#		resume.jobs.each do |job|
#			assert_not_nil job.title.match(/^UPDATED /)
#		end
#		resume.schools.each do |school|
#			assert_not_nil school.name.match(/^UPDATED /)
#		end
#		resume.publications.each do |publication|
#			assert_not_nil publication.name.match(/^UPDATED /)
#		end
#		resume.affiliations.each do |affiliation|
#			assert_not_nil affiliation.organization.match(/^UPDATED /)
#		end
#		resume.languages.each do |language|
#			assert_not_nil language.name.match(/^UPDATED /)
#		end
#	end

	%w( affiliation language job publication school skill ).each do |component|
		test "should update #{component} on resume update" do
			resume = resume_with_components
			comps = []
			resume.send(component.pluralize).each do |comp|
				comps.push( { :id => comp.id, comp.default_field => "UPDATED " + comp.default } )
			end
			resume.update_attributes( { 
				"#{component.pluralize}_attributes" => comps
			} )
			resume.reload.send(component.pluralize).each do |comp|
				assert_not_nil comp.default.match(/^UPDATED /)
			end
		end

		test "should delete #{component} on resume update" do
			resume = resume_with_components
			comp  = resume.send(component.pluralize).first
#			comps = [{:id => comp.id, :_delete => true }]
			comps = [{:id => comp.id, :_destroy => true }]
			assert_difference( "Resume.find(#{resume.id}).send('#{component.pluralize}').length", -1 ) do
				resume.update_attributes( { "#{component.pluralize}_attributes" => comps } )
			end
		end
	end

protected

	def create_resume(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:resume,options)
		record.save
		record
	end

end

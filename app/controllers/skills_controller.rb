class SkillsController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@skill = @resume.skills.new({
			:name       => 'Name',
			:level_id   => 1,
			:start_date_string => Date.today.to_s,
			:end_date_string   => Date.today.to_s
		})
		@skill.save!
	rescue
		flash.now[:error] = 'Skill creation FAILED!'
		render :text => ''
	end

	def order
		params[:skills].each { |id| @resume.skills.find(id).move_to_bottom }
		respond_to do |format|
#	TODO
#			format.html {}
			format.js { render :text => '' }
		end
	end

end

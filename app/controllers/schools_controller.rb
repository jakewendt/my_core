class SchoolsController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@school = @resume.schools.new({
			:name        => 'School Name',
			:degree      => 'Degree',
			:location    => 'Location',
			:description => 'Description',
			:start_date_string  => Date.today.to_s,
			:end_date_string    => Date.today.to_s
		})
		@school.save!
	rescue
		flash.now[:error] = 'School creation FAILED!'
		render :text => ''
	end

end

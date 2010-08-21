class JobsController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@job = @resume.jobs.new({
			:title			=> 'Job Title',
			:company		=> 'Company',
			:location	 => 'Location',
			:description => 'Description',
			:start_date_string => Date.today.to_s,
			:end_date_string	 => Date.today.to_s
		})
		@job.save!
	rescue
		flash.now[:error] = 'Job creation FAILED!'
		render :text => ''
	end

end

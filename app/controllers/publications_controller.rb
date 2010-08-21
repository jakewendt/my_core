class PublicationsController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@publication = @resume.publications.new({
			:name => 'Name',
			:contribution => 'Contribution',
			:title => 'Title',
			:url => 'Link',
			:date_string => Date.today.to_s
		})
		@publication.save!
	rescue
		flash.now[:error] = 'Publication creation FAILED!'
		render :text => ''
	end

end

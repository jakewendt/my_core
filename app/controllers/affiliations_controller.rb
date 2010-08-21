class AffiliationsController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@affiliation = @resume.affiliations.new({
			:start_date_string => Date.today.to_s,
			:end_date_string	 => Date.today.to_s,
			:organization => 'Organization',
			:relationship => 'Relationship'
		})
		@affiliation.save!
	rescue
		flash.now[:error] = 'Affiliation creation FAILED!'
		render :text => ''
	end

#	def destroy
#		@affiliation = @resume.affiliations.find(params[:id])
#		unless @affiliation.destroy
#			flash.now[:error] = 'Affiliation deletion FAILED!'
#			render :text => ''
#		end
#	end

end

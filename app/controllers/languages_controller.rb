class LanguagesController < ApplicationController

	acts_as_resume_component

#	TODO
#	add respond_to blocks

	def create
		@language = @resume.languages.new({
			:name		 => 'Name',
			:level_id => 1
		})
		@language.save!
	rescue
		flash.now[:error] = 'Language creation FAILED!'
		render :text => ''
	end

	def order
		params[:languages].each { |id| @resume.languages.find(id).move_to_bottom }
		respond_to do |format|
#	TODO
#			format.html {}
			format.js { render :text => '' }
		end
	end

end

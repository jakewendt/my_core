module ResumeComponentController
	
	def self.included(base)
		base.extend ClassMethods
	end
	
	module ClassMethods
		def acts_as_resume_component

			#	index, show, new, edit, create, update, destroy
			before_filter :login_required
			before_filter :get_resume
			before_filter :require_owner

			# no direct access except: create, destroy and order

#			define_method "index" do
#				redirect_to resume_url(@resume)
#			end
#
#			define_method "show" do
#				redirect_to resume_url(@resume)
#			end
#
#			define_method "new" do
#				redirect_to resume_url(@resume)
#			end
#
#			define_method "edit" do
#				redirect_to resume_url(@resume)
#			end
#
#			define_method "update" do
#				redirect_to resume_url(@resume)
#			end

			protected

			define_method "get_resume" do
				@resume = Resume.find(params[:resume_id])
			end

		end
	end
end


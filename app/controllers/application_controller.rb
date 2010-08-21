# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

	helper :all # include all helpers, all the time

	include AuthenticatedSystem
	include CommentableController
	include PhotoableController

	# don't show passwords in logs
	filter_parameter_logging 'password'

	# See ActionController::RequestForgeryProtection for details
	# Uncomment the :secret if you're not using the cookie session store
	protect_from_forgery # :secret => 'afe76908822b45fd48062836e82f84bd'

protected

	def require_owner
		obj = controller_name.singularize
#
#	I think that I should use delegate on these things
#	delegate won't work here bc @job, @item, etc. don't exist for several actions
#	Need to use the parent object on actions like new, create and index as there is no obj
#
		obj = 'resume' if "job school skill affiliation publication language".include?(obj)
		obj = 'board'	 if "magnet".include?(obj)
		obj = 'list'	 if "item".include?(obj)
		obj = 'blog'	 if "entry".include?(obj)
		obj = 'trip'	 if "stop".include?(obj)
		object = eval('@'+obj)
		unless ( logged_in? && ( ( current_user.id == object.user.id ) || current_user.has_role?('administrator') ) )
			permission_denied("Sorry, but this is not your #{obj}")
		end
	end

	def check_public(object)
		unless ( object.public || 
			( logged_in? && ( ( current_user == object.user ) || current_user.has_role?('administrator') ) ) ) 
			flash[:notice] = "The owner has marked this item as private"
			permission_denied
		end
	end

	def check_pdf_download
		if %w( pdf ).include?(params[:format]) &&
			%w( mystuff notes lists blogs trips assets resumes ).include?(params[:controller])
			@download = current_user.downloads.new(:url => request.env["REQUEST_URI"])
			if @download.save
				flash[:notice] = 'Download was successfully created.'
				redirect_to(@download)
			else
				flash[:error] = 'Download creation failed.'
				redirect_back_or_default(params.delete_keys!(:format))
			end
		end
	end

#before_filter :set_user_language
#def set_user_language
#  I18n.locale = current_user.language if logged_in?
#end
end

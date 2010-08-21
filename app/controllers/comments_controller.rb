class CommentsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :only => [ :edit, :update, :destroy ]
	before_filter :get_comment
	before_filter :require_owner, :only => [ :edit, :update, :destroy ]

	def update
		if @comment.update_attributes(params[:comment])
			flash[:notice] = 'Comment was successfully updated.'

#
# If I make this rjs, I won't have to redirect
# which will also allow me to remove one of the
# special routes that I had to add specifically
# for this.
#

			redirect_to polymorphic_url(@comment.commentable)
		else
			flash.now[:error] = "An error occured updating this comment."
			render :action => "edit"
		end
	end

	def destroy
		@comment.destroy
		respond_to do |format|
			format.html { redirect_back_or_default(@comment.commentable) }
			format.js do
				render :update do |page|
					page.remove dom_id(@comment)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#comments_count') ) {"
					page.replace_html "comments_count", @comment.commentable.comments.count
					page << "}"
				end
			end
		end
	end

	def edit
		@page_title = "Edit Comment"
	end

#	def new;		 redirect_to root_path; end
#	def create;	redirect_to root_path; end
#	def index;	 redirect_to root_path; end
#	def show;		redirect_to root_path; end
 
protected

	def get_comment
		@comment = Comment.find( params[:id] ) if params[:id]
	end

# this require_owner includes the commentable's owner
	def require_owner
		unless ( logged_in? && ( ( current_user.id == @comment.user_id ) || current_user.has_role?('administrator') || ( current_user.id == @comment.commentable.user.id ) ) )
			permission_denied("Sorry, but this is not your comment.")
		end 
	end

end

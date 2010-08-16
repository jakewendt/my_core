# add "include CommentableController" to application_controller.rb
module CommentableController
	
	def self.included(base)
		base.extend ClassMethods
	end
	
	module ClassMethods
		
		def add_create_comment(object_name)

			# add_create_comment :stop

			define_method "create_comment" do
				@commentable = instance_variable_get("@#{object_name}")
				@comment = @commentable.comments.new(params[:comment])
				@comment.user_id = current_user.id
				if @comment.save
					render :update do |page|
						page.insert_html :bottom, "comments", :partial => 'comments/show', :locals => { :comment => @comment }
						page.visual_effect :highlight, dom_id(@comment), :duration => 1
						page[:new_comment].reset
						page.replace_html :comments_count, @comment.commentable.comments.count
					end
				else
#
#	Insert some RJS in here so that the user knows it fails
#
					flash.now[:error] = "Comment save failed."
					render :text => ''
				end
			end

		end
	end
end

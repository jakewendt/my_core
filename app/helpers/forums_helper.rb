module ForumsHelper

#	def manage_forum(forum)
#		if logged_in? and current_user.has_role?('administrator')
#			content_tag(:small) do
#				edit_forum(forum) +"&nbsp;"+ delete_forum(forum)
#			end
#		else
#			"&nbsp;"
#		end
#	end

#	def edit_forum(forum)
#		"["+ link_to( 'edit', edit_forum_path(forum) )+"]"
#	end

#	def delete_forum(forum)
#		"["+ link_to( 'delete', forum_path(forum), 
#			:method => :delete, 
#			:confirm => 'Are you sure? This will delete this entire forum.' ) +"]"
#	end

end

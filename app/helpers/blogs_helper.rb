module BlogsHelper

	def classes_for_blog(blog)
		classes = ['row']
		classes.push('otheruser') if blog.user_id != current_user.id
		classes.push('public') if blog.public
		classes.join(' ')
	end

#	def blog_menu(blog)
#		menu_items = [
#			link_to( 'Export as TXT', blog_path(blog, :format => :txt) ),
#			link_to( 'Export as PDF', blog_path(blog, :format => :pdf) )
#		]
#		menu_items.push(
#			link_to( 'Add Entry', new_blog_entry_path(blog) ),
#			link_to( 'Edit', edit_blog_path(blog) ),
#			"<hr/>",
#			link_to( 'Destroy', blog_path(blog),
#				:confirm => "Delete #{blog.title}?\nAre you sure?",
#				:method => :delete ) ) if editable?(blog)
#		css_menu('Blog',menu_items)
#	end

end

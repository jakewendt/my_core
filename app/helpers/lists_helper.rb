module ListsHelper

	def classes_for_list(list)
		classes = ['row']
		classes.push('otheruser') if list.user_id != current_user.id
		classes.push('public') if list.public
		classes.join(' ')
	end

#	def list_menu(list)
#		menu_items = [ 
#			link_to( 'Convert to Note', convert_to_note_list_path(list) ),
#			link_to( 'Copy', copy_list_path(list) ),
#			link_to( 'Export as TXT', list_path(list, :format => :txt) ),
#			link_to( 'Export as PDF', list_path(list, :format => :pdf) ) ]
#		menu_items.push(
#			link_to( 'Edit', edit_list_path(list) ),
#			"<hr/>",
#			link_to( 'Destroy', list_path(list),
#				:confirm => "Delete #{list.title}?\nAre you sure?",
#				:method => :delete ) ) if editable?(list)
#		css_menu('List',menu_items)
#	end

end

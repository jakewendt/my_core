module NotesHelper

	def classes_for_note(note)
		classes = ['row']
		classes.push('otheruser') if note.user_id != current_user.id
		classes.push('public') if note.public
		classes.join(' ')
	end

#	def note_menu(note)
#		menu_items = [
#			link_to( 'Convert to List', convert_to_list_note_path(note) ),
#			link_to( 'Copy', copy_note_path(note) ),
#			link_to( 'Export as TXT', note_path(note, :format => :txt) ),
#			link_to( 'Export as PDF', note_path(note, :format => :pdf) ),
#			link_to_function( 'Decrypt', "Decrypt_ID('note_body')" ) ]
#		menu_items.push(
#			link_to( 'Edit', edit_note_path(note) ),
#			"<hr/>",
#			link_to( 'Destroy', note_path(note),
#				:confirm => "Delete #{note.title}?\nAre you sure?",
#				:method => :delete ) ) if editable?(note)
#		css_menu('Note',menu_items)
#	end
#
#	def edit_note_menu(note)
#		menu_items = [
#			link_to_function( 'Encrypt', "Encrypt_ID('note_body')" ),
#			link_to_function( 'Decrypt', "Decrypt_ID('note_body')" ),
#			"<hr/>",
#			link_to( 'Destroy', note_path(note),
#				:confirm => "Delete #{note.title}?\nAre you sure?",
#				:method => :delete ) ]
#		css_menu('Note',menu_items)
#	end

end

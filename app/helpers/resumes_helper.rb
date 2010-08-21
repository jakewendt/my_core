module ResumesHelper

	def classes_for_resume(resume)
		classes = ['row']
		classes.push('otheruser') if resume.user_id != current_user.id
		classes.push('public') if resume.public
		classes.join(' ')
	end

#	def resume_menu(resume)
#		menu_items = [
#			link_to( 'Export as TXT', resume_path(resume, :format => :txt) ),
#			link_to( 'Export as PDF', resume_path(resume, :format => :pdf) ) ]
#		menu_items.push(
#			link_to( 'Edit', edit_resume_path(resume) ),
#			"<hr/>",
#			link_to( 'Destroy', resume_path(resume),
#				:confirm => "Delete #{resume.title}?\nAre you sure?",
#				:method => :delete ) ) if editable?(resume)
#		css_menu('Resume',menu_items)
#	end

end

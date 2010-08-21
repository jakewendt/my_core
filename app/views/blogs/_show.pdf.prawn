pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text blog.title, :size => 20, :style => :bold, :align => :center
pdf.move_down(10)

unless blog.description.blank?
	pdf.text blog.description, :size => 12
	pdf.move_down(10)
end

pdf.text "Created on #{blog.created_at.to_s(:basic)}", :size => 12, :align => :center
pdf.text "Last updated on #{blog.updated_at.to_s(:basic)}", :size => 12, :align => :center
pdf.move_down(10)

if blog.entries_count > 0
	render :partial => 'entries/show', 
		:collection => blog.entries, 
		:as => :entry,
		:locals => { :parent_pdf => pdf }
else
	pdf.text "This blog currently has no entries.", :size => 16
end

if( !!defined?(show_counter) && !!defined?(total_count) && (( show_counter + 1 ) < total_count ) )
	pdf.start_new_page
end

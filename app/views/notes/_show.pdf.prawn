pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text note.title, :size => 20, :style => :bold, :align => :center
pdf.move_down(10)

unless note.body.blank?
	pdf.text note.body, :size => 12
	pdf.move_down(10)
end

pdf.text "Created on "+note.created_at.to_s(:basic), :size => 12, :align => :center
pdf.text "Last updated on "+note.updated_at.to_s(:basic), :size => 12, :align => :center

if( !!defined?(show_counter) && !!defined?(total_count) && (( show_counter + 1 ) < total_count ) )
pdf.start_new_page
end

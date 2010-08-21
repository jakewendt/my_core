pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text list.title, :size => 20, :style => :bold, :align => :center
pdf.text "\nIncomplete:\n\n", :size => 18
list.items.incomplete.each { |i| 
	pdf.text "\t"*3+i.content, :size => 14 }
pdf.text "\nComplete:\n\n", :size => 18
list.items.complete.each	{ |i| 
	pdf.text "\t"*3+i.content, :size => 14 }
pdf.move_down(10)
unless list.description.blank?
	pdf.text list.description, :size => 12
	pdf.move_down(10)
end
pdf.text "Created on "+list.created_at.to_s(:basic), :size => 12, :align => :center
pdf.text "Last updated on "+list.updated_at.to_s(:basic), :size => 12, :align => :center

if( !!defined?(show_counter) && !!defined?(total_count) && (( show_counter + 1 ) < total_count ) )
pdf.start_new_page
end

pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text trip.title, :size => 20, :style => :bold, :align => :center
pdf.move_down(10)

unless trip.description.blank?
	pdf.text trip.description, :size => 12
	pdf.move_down(10)
end

pdf.text "Created on #{trip.created_at.to_s(:basic)}", :size => 12, :align => :center
pdf.text "Last updated on #{trip.updated_at.to_s(:basic)}", :size => 12, :align => :center
pdf.move_down(10)

if trip.stops_count > 0
	render :partial => 'stops/show', 
		:collection => trip.stops, 
		:as => :stop,
		:locals => { :parent_pdf => pdf }
else
	pdf.text "This trip currently has no stops.", :size => 16
end

if( !!defined?(show_counter) && !!defined?(total_count) && (( show_counter + 1 ) < total_count ) )
pdf.start_new_page
end

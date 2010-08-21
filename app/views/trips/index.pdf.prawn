pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.move_down(200)
pdf.text "Trips by #{current_user.login}", :size => 30, :style => :bold, :align => :center
pdf.move_down(100)
pdf.text "Downloaded on #{Time.now.to_s(:basic)}", :size => 20, :align => :center
pdf.start_new_page

pdf.text "Table of Contents", :size => 20, :align => :center, :style => :bold
pdf.move_down(30)
@trips.each do |trip|
	pdf.text trip.title, :size => 18
end
if @trips.length > 0
	pdf.start_new_page
end

render :partial => 'trips/show', 
	:collection => @trips,
	:as => :trip,
	:locals => {
		:total_count => @trips.length,
		:parent_pdf => pdf
	}

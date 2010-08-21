pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.move_down(200)
pdf.text "Notes by #{current_user.login}", :size => 30, :style => :bold, :align => :center
pdf.move_down(100)
pdf.text "Downloaded on "+Time.now.to_s(:basic), :size => 20, :align => :center
pdf.start_new_page

pdf.text "Table of Contents", :size => 20, :align => :center, :style => :bold
pdf.move_down(30)
@notes.each do |note|
	pdf.text note.title
end
if @notes.length > 0
	pdf.start_new_page
end

render :partial => 'notes/show.pdf.prawn', 
	:collection => @notes,
	:as => :note,
	:locals => {
		:total_count => @notes.length,
		:parent_pdf => pdf
	}

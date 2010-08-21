pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.move_down(200)
pdf.text "Assets by #{current_user.login}", :size => 30, :style => :bold, :align => :center
pdf.move_down(100)
pdf.text "Downloaded on "+Time.now.to_s(:basic), :size => 20, :align => :center
pdf.start_new_page

render :partial => 'assets/show.pdf.prawn', 
	:collection => @assets,
	:as => :asset,
	:locals => {
		:total_count => @assets.length,
		:parent_pdf => pdf
	}

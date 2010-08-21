pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.move_down(200)
pdf.text "Your Stuff by #{current_user.login}", :size => 30, :style => :bold, :align => :center
pdf.move_down(100)
pdf.text "Downloaded on #{Time.now.to_s(:basic)}", :size => 20, :align => :center

if @notes.length > 0
	pdf.start_new_page
end

render :file => 'notes/index', :locals => { :parent_pdf => pdf }

if @lists.length > 0
	pdf.start_new_page
end

render :file => 'lists/index', :locals => { :parent_pdf => pdf }

if @blogs.length > 0
	pdf.start_new_page
end

render :file => 'blogs/index', :locals => { :parent_pdf => pdf }

if @trips.length > 0
	pdf.start_new_page
end

render :file => 'trips/index', :locals => { :parent_pdf => pdf }

if @resumes.length > 0
	pdf.start_new_page
end

render :file => 'resumes/index', :locals => { :parent_pdf => pdf }

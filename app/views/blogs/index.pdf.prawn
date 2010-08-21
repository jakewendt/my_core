pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.move_down(200)
pdf.text "Blogs by #{current_user.login}", :size => 30, :style => :bold, :align => :center
pdf.move_down(100)
pdf.text "Downloaded on #{Time.now.to_s(:basic)}", :size => 20, :align => :center
pdf.start_new_page

pdf.text "Table of Contents", :size => 20, :align => :center, :style => :bold
pdf.move_down(30)
@blogs.each do |blog|
	pdf.text blog.title, :size => 18
end
if @blogs.length > 0
	pdf.start_new_page
end

render :partial => 'blogs/show', 
	:collection => @blogs,
	:as => :blog,
	:locals => {
		:total_count => @blogs.length,
		:parent_pdf => pdf
	}

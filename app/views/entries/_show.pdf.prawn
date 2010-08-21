pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "#{entry.title} (created on #{entry.created_at.to_s(:basic)})", :size => 18, :style => :bold
pdf.move_down(20)
unless entry.body.blank?
	pdf.text entry.body, :size => 16
	pdf.move_down(20)
end

#	entry.photos.each do |photo|
#	#
#	#	I have to put each photo on a separate page because, despite what the website says,
#	#	images do NOT flow well.  Sometimes they maintain the same y position, but get
#	#	kicked to the next page, but the text position thinks that they didn't so there is
#	#	a gap and then the image is behind the text.  I have no idea how anyone else does this.
#	#
#		if !photo.file.blank?
#	#		pdf.start_new_page
#	#		pdf.image "#{RAILS_ROOT}/public#{url_for_file_column(photo, 'file')}",
#	#			:position => :center, :width => 550
#	#		pdf.move_down(10)
#			pdf.text "#{RAILS_ROOT}/public#{url_for_file_column(photo, 'file')}"
#			pdf.move_down(10)
#			pdf.text "http://#{request.host_with_port}#{url_for_file_column(photo, 'file')}"
#		end
#		pdf.move_down(10)
#		pdf.text "Caption: #{photo.caption}"
#	end
#	if entry.photos.length > 0
#		pdf.start_new_page
#	end

if entry.comments.length > 0
	pdf.text "Comments ... ", :size => 16
	pdf.move_down(20)
	render :partial => 'comments/show', 
		:collection => entry.comments, 
		:as => :comment,
		:locals => { :parent_pdf => pdf }
else
	pdf.text "This entry has no comments.", :size => 16
end

pdf.move_down(20)

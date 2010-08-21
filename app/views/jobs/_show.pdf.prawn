pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "#{job.title} ( #{job.start_date.to_s(:month_year)} - #{job.end_date_to_s} )"

pdf.text "#{job.company} - #{job.location}"

unless job.description.blank?
	pdf.text job.description 
end

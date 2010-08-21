pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "#{school.name} ( #{school.start_date.to_s(:month_year)} - #{school.end_date_to_s} )"

unless school.degree.blank?
	pdf.text school.degree
end

unless school.location.blank?
	pdf.text school.location
end

unless school.description.blank?
	pdf.text school.description
end

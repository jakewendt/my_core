pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "#{affiliation.relationship} #{affiliation.organization} ( #{affiliation.start_date.to_s(:month_year)} - #{affiliation.end_date_to_s} )"

pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "#{publication.title} ( #{publication.date.to_s(:month_year)} )"
pdf.text "#{publication.name} #{publication.contribution} #{publication.url}"

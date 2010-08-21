pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text asset.title, :size => 14, :style => :bold

#	
#	ActionView::TemplateError (failed to allocate memory) on line #15 of app/views/assets/index.pdf.prawn:
#	12: 	:locals => {
#	13: 		:total_count => @assets.length,
#	14: 		:parent_pdf => pdf
#	15: 	}
#	
#	    app/views/assets/index.pdf.prawn:15:in `_run_prawn_app47views47assets47index46pdf46prawn'
#	
#	Rendered rescues/_trace (39.5ms)
#	Rendered rescues/_request_and_response (1.5ms)
#	Rendering rescues/layout (internal_server_error)
#	

#	pdf.text "Description: #{asset.description}"
#	pdf.text "Model: #{asset.model}"
#	pdf.text "Serial: #{asset.serial}"
#	pdf.text "Cost: #{number_to_currency(asset.cost)}"
#	pdf.text "Value: #{number_to_currency(asset.value)}"
#	pdf.text "Acquired on: #{asset.acquired_on}"
#	pdf.text "Used on: #{asset.used_on}"
#	pdf.text "Sold on: #{asset.sold_on}"
#	pdf.text "Creators(s): #{asset.creator_names}"
#	pdf.text "Category(s): #{asset.category_names}"
#	pdf.text "Location(s): #{asset.location_names}"

pdf.move_down(10)

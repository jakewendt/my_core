pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Affiliations:', :style => :bold

render :partial => 'affiliations/show', :collection => affiliations, :as => :affiliation,
	:locals => { :parent_pdf => pdf }

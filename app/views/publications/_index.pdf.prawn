pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Publications:', :style => :bold

render :partial => 'publications/show', :collection => publications, :as => :publication,
	:locals => { :parent_pdf => pdf }

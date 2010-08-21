pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'notes/show.pdf.prawn', :locals => { 
	:parent_pdf => pdf,
	:note => @note 
}

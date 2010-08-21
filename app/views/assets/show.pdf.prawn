pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'assets/show.pdf.prawn', :locals => { 
	:parent_pdf => pdf,
	:asset => @asset 
}

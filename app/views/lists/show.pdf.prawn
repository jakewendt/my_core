pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'lists/show.pdf.prawn', :locals => { 
	:parent_pdf => pdf,
	:list => @list
}

pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'trips/show', :locals => { 
	:parent_pdf => pdf,
	:trip => @trip 
}

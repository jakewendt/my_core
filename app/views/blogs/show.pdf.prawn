pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'blogs/show', :locals => { 
	:parent_pdf => pdf,
	:blog => @blog 
}

pdf = parent_pdf if ( !!defined?(parent_pdf) )

render :partial => 'resumes/show', :locals => { 
	:parent_pdf => pdf,
	:resume => @resume 
}

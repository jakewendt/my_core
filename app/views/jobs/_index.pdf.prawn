pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Experience:', :style => :bold

render :partial => 'jobs/show', :collection => jobs, :as => :job,
	:locals => { :parent_pdf => pdf }

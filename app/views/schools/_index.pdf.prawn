pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Education:', :style => :bold

render :partial => 'schools/show', :collection => schools, :as => :school,
	:locals => { :parent_pdf => pdf }

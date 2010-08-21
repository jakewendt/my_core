pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text resume.title, :size => 20, :style => :bold, :align => :center

pdf.move_down(20)

unless resume.objective.blank?
	pdf.text "Objective:", :style => :bold
	pdf.text resume.objective
end

pdf.move_down(20)

unless resume.summary.blank?
	pdf.text "SUMMARY:", :style => :bold
	pdf.text resume.summary
end

pdf.move_down(20)

if resume.jobs_count > 0
render :partial => 'jobs/index', :locals => { :parent_pdf => pdf, :jobs => resume.jobs }
pdf.move_down(20)
end

if resume.schools_count > 0
render :partial => 'schools/index', :locals => { :parent_pdf => pdf, :schools => resume.schools }
pdf.move_down(20)
end

if resume.skills_count > 0
render :partial => 'skills/index', :locals => { :parent_pdf => pdf, :skills => resume.skills }
pdf.move_down(20)
end

if resume.publications_count > 0
render :partial => 'publications/index', :locals => { :parent_pdf => pdf, :publications => resume.publications }
pdf.move_down(20)
end

if resume.affiliations_count > 0
render :partial => 'affiliations/index', :locals => { :parent_pdf => pdf, :affiliations => resume.affiliations }
pdf.move_down(20)
end

if resume.languages_count > 0
render :partial => 'languages/index', :locals => { :parent_pdf => pdf, :languages => resume.languages }
pdf.move_down(20)
end

unless resume.other.blank?
	pdf.text "Other:", :style => :bold
	pdf.text resume.other
end

if( !!defined?(show_counter) && !!defined?(total_count) && (( show_counter + 1 ) < total_count ) )
pdf.start_new_page
end

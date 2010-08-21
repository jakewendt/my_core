pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text "On #{comment.created_at.to_s(:long)}, #{comment.user.login} said ... ", :size => 14
pdf.move_down(20)
unless comment.body.blank?
	pdf.text comment.body, :size => 12
	pdf.move_down(20)
end

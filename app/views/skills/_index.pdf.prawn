pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Skills:', :style => :bold

pdf.move_down(10)

sks = skills.map do |skill|
	[ 
		skill.name, 
		skill.level.name, 
		skill.start_date.to_s(:month_year),
		skill.end_date_to_s,
		skill.years_experience
	]
end

pdf.table sks, :border_style => :grid,
	:row_colors => ["FFFFFF","DDDDDD"],
	:headers => ["Skill", "Level","First","Last","Years"],
	:column_widths => { 0 => 200, 1 => 100, 2 => 75, 3 => 75, 4 => 75 },
	:align => { 0 => :left, 1 => :center, 2 => :center, 3 => :center, 4 => :center },
	:header_color => 'f07878',
	:header_text_color  => "990000"

#	:align_headers => { 0 => :center, 2 => :left, 3 => :left, 4 => :right }

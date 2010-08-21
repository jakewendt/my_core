pdf = parent_pdf if ( !!defined?(parent_pdf) )

pdf.text 'Languages:', :style => :bold

pdf.move_down(10)

langs = languages.map do |language|
	[ language.name, language.level.name ]
end

pdf.table langs, :border_style => :grid,
  :row_colors => ["FFFFFF","DDDDDD"],
  :headers => ["Language", "Level"],
	:column_widths => { 0 => 300, 1 => 200 },
	:align => { 0 => :left, 1 => :center },
	:header_color => 'f07878',
	:header_text_color  => "990000"

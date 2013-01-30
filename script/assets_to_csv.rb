#!/usr/bin/env /home/jakewen/subdomains/my_core/script/runner

require 'fastercsv'

columns = Asset.column_names
columns << 'category_names'
columns << 'creator_names'
columns << 'location_names'

File.open('assets.csv','w') do |f|
	f.puts columns.to_csv( :headers => true)
	Asset.all.each do |asset|
		f.puts columns.collect{|c| asset.send(c) }.to_csv
	end
end

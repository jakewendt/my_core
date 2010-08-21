module AssetsHelper

	def classes_for_asset(asset)
		classes = ['row']
		classes.push('for_sale') if asset.for_sale?
		classes.push('sold')     if asset.sold?
		classes.push('want')     if asset.want?
		classes.push('borrowed') if asset.borrowed?
		classes.push( (asset.used?)?'used':'unused' )
		classes.join(' ')
	end

	def filter_link_to(name, current, filter)
		new_params = HashWithIndifferentAccess.new

		#	doesn't matter how often I dup, it still changes the original params hash!!!!

		filter.keys.each do |key|
			if current.has_key?(key) && !current[key].blank?
				values = [current[key]].flatten.downcase
				filter[key] = filter[key].downcase
				if    values.include?(filter[key])
					#	no change to parameters so link to self
				elsif( filter[key].index('!') != 0 )and( values.include?("!#{filter[key]}") )	
					#	new filter is positive and current is negative
					new_params[key] = (values + [filter[key]] - ["!#{filter[key]}"])	#.join(',')
				elsif( filter[key].index('!') == 0 )and( values.include?(filter[key].slice(1..-1)) ) 
					#	new filter is negative and current is positive
					new_params[key] = (values + [filter[key]] - [filter[key].slice(1..-1)])	#.join(',')
				else
					new_params[key] = values.push(filter[key])	#.join(',')
				end
			else
				new_params[key] = [filter[key]]
			end
		end
		#	Remove :page as the new filter could have less than one page which will 
		#	not have the pagination links and the user won't be able to change it.
		link_to( name, current.merge(new_params).delete_keys!(:page) )
	end

	def clear_filter_link_to(prefix,current,remove_filter)
		new_params = HashWithIndifferentAccess.new

		remove_filter.keys.each do |key|
			#	ensure both current[key] and remove_filter[key] are arrays
			new_params[key] = [current[key]].flatten - [remove_filter[key]].flatten
			new_params[key] = [] if new_params[key].blank?
		end

		f = "<div class='filter'>" <<
			"<span class='name'>"
		f << [remove_filter[remove_filter.keys.first]].flatten.first.gsub('_',' ')
#		f << if remove_filter[remove_filter.keys.first].is_a?(Array)
#				remove_filter[remove_filter.keys.first][0].gsub('_',' ')
#			else
#				remove_filter[remove_filter.keys.first].gsub('_',' ')
#			end
		f << "</span>"
		f << link_to( image_tag('milky_cancel.png'), current.merge(new_params), 
				:class => 'clear_filter', :title => "Remove this filter" ) <<
			"</div><!-- class='filter' -->"
	end

	def filter_links_for(current,filter)
		remove_params = HashWithIndifferentAccess.new
		negate_params = HashWithIndifferentAccess.new
		posate_params = HashWithIndifferentAccess.new

		f = "<div class='filter'>" <<
			"<span class='name'>#{filter[filter.keys.first].gsub('_',' ')}</span>"

		# this really only does 1 key, but ...
		filter.keys.each do |key|

			if current[key].reject{|s| s.index("!") != 0 }.include?(filter[key])
				posate_params[key] = [current[key]].flatten - [filter[key]] + [filter[key].slice(1..-1)]
				posate_params[key] = [] if posate_params[key].blank?
			end

			if current[key].reject{|s| s.index("!") == 0 }.include?(filter[key])
				negate_params[key] = [current[key]].flatten - [filter[key]] + ["!#{filter[key]}"]
				negate_params[key] = [] if negate_params[key].blank?
			end

			remove_params[key] = [current[key]].flatten - [filter[key]]
			remove_params[key] = [] if remove_params[key].blank?
		end

		if !posate_params.empty?
			f << link_to( image_tag('milky_add.png'), current.merge(posate_params), 
				:class => 'posate_filter', :title => "Assert this positive filter" )
		end

		if !negate_params.empty?
			f << link_to( image_tag('milky_remove.png'), current.merge(negate_params), 
				:class => 'negate_filter', :title => "Negate this filter" )
		end

		f << link_to( image_tag('milky_cancel.png'), current.merge(remove_params), 
			:class => 'clear_filter', :title => "Remove this filter" ) <<
			"</div><!-- class='filter' -->"
		f
	end

end

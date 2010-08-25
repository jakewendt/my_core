# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def filter_and_sort_select_tags(model)
		#	if I remove the space between the 2 select_tags, they get pushed to the top?
		return "<div id='filter_and_sort_select_tags'>"<<
			filter_select_tag << "&nbsp;" << sort_select_tags(model) <<
			"</div><!-- id='filter_and_sort_select_tags' -->"
	end

	def filter_select_tag
		return "<div id='new_filters' style='display:none'>" <<
			select_tag('new_tag_filter', tags_for_select,  { :name => 'tags[]', :class => 'filter' }) <<
			"</div><!-- id='new_filters' -->"
	end

	def sort_select_tags(model)
		#	if I remove the space between the 2 select_tags, they get pushed to the top?
		return "<div id='sort_select_tags' style='display:none;'>" <<
		select_tag('sort', options_for_select(model.constantize::SORTABLE_COLUMNS, 
			:selected => params[:sort]), :class => 'sort' ) << " " <<
		select_tag('dir', options_for_select(%w(ASC DESC), 
			:selected => params[:dir]), :class => 'dir' ) <<
			"</div><!-- id='sort_select_tags' -->"
	end

	def controlframe(title, icon='note.png', &block)
		#	This is stupid.  I've tried to make this dry by putting the capture(&block)
		#	inside a (block_given?)?: but it either doesn't show or shows twice
		if block_given?
			concat(content_tag(:div, :class => "controlframe") do
				image_tag( icon ) +
				content_tag(:div, :class => "control bar") do
					"#{content_tag(:b, title)} #{capture(&block)}"
#	I don't know why, but using the + as below no longer works?????
#					content_tag(:b, title) + capture(&block)
				end
			end)
		else
			content_tag(:div, :class => "controlframe") do
				image_tag( icon ) +
				content_tag(:div, :class => "control bar") do
					content_tag(:b, title)
				end
			end
		end
	end

	def add_search_form(search_path,params={})
		search_form = ""
		if( controller.controller_name != 'users' )
			search_form << "<form action='" << search_path << "' method='get'>"
			params.keys.each do |k|
				next if %w(title action controller).include?(k.to_s)
				search_form << if params[k].is_a?(Array)
					params[k].collect{|v| hidden_field_tag( k+'[]', v, :id => nil ) }.join()
				else
					hidden_field_tag( k, params[k], :id => nil )
				end
			end
			search_form << "<p class='search'>Title like: " <<
				text_field_tag( :title, params[:title]) << " " <<
				submit_tag( "Search all Public", :name => nil ) <<
				"</p>"
#	This mucks up testing when there aren't any tags.  Add some tags to the search tests.
#			search_form << select_tag('tags', options_for_select(Tag.find(:all,:conditions => {:user_id => current_user.id}).collect(&:name)), :multiple => true)
			search_form << "</form>"
		end
		return search_form
	end

	def editable?(object)
		logged_in? && ( object.user.id == current_user.id || current_user.has_role?('administrator') )
	end

	def section_header(title)
		content_tag :p, content_tag(:b, title), :class => 'section_header'
	end

	def section(title, content)
		if !content.blank?
			(section_header(title)) + (content_tag :div, sanitize(textilize((content))), :class => 'description')
		end
	end

	def manage_links_for(components, options={} )
		return unless components
		config = { 
			:edit => true
		}
		# update replaces caller, while merge does not.
		config.update(options) if options.is_a?(Hash)
		if !components.is_a?(Array)
			components = [components]
		end
		unless config[:confirm]
			if( components.last.has_attribute?( :title ) )
				config[:confirm] = components.last.title
			else
				config[:confirm] = "Unknown"
			end
		end

		markaby do
			span.manage do
				if editable?(components.first)
					if config[:edit]
						link_to "Edit", edit_polymorphic_path(components).to_s
						span " | "
					end

					link_to 'Destroy', 
						polymorphic_path([components.last], :action => 'confirm_destroy').to_s, 
						:title => config[:confirm],
						:class => 'ajax_confirm_destroy'
				else
					"&nbsp;"	#	without this, the css gets a little compressed
				end
			end
		end
	end

	def markaby(&block)
		Markaby::Builder.new({}, self, &block)
	end

end

module CssMenuHelper

	def css_menu(title,menu_items)
		return "<div class='menu_item'>" <<
			"<span>#{title}</span>" <<
			"<div class='sub_menu'>\n    " <<
			menu_items.join("\n    ") <<
			"</div><!-- sub_menu --></div><!-- menu_item #{title} -->"
	end

	def main_menu
		menu_items = [ link_to( 'Contact Me', compose_path ) ]
		Page.non_help_pages.each do |page|
			menu_items.push( link_to( page.title, page_path(page) ) ) if !page.first?
		end
		css_menu( link_to( 'my.jakewendt.com', root_path ), menu_items)
	end

	def new_menu
		css_menu('New',[
			link_to( 'List',         new_list_path ),
			link_to( 'Note',         new_note_path ),
			link_to( 'Blog',         new_blog_path ),
			link_to( 'Travel Blog',  new_trip_path ),
			link_to( 'Resume',       new_resume_path ),
			link_to( 'Poetry Board', new_board_path )
		])
	end

	def games_menu
		css_menu('Games',[
			link_to( 'Mine Sweeper', new_mine_sweeper_path ),
			link_to( 'Yahtzee', yahtzee_path ),
			link_to( 'Blackjack', blackjack_path )
		])
	end

	def search_menu
		css_menu('Search',[
			link_to( 'Lists',         lists_path ),
			link_to( 'Notes',         notes_path ),
			link_to( 'Blogs',         blogs_path ),
			link_to( 'Travel Blogs',  trips_path ),
			link_to( 'Resumes',       resumes_path ),
			link_to( 'Poetry Boards', boards_path )
		])
	end

	def help_menu
		menu_items = Page.help_pages.collect do |page|
		  link_to( page.title, page.path )
		end
		css_menu('Help', menu_items )
	end

	def admin_menu
		css_menu('Admin',[
			link_to( 'Users', users_path ),
			link_to( 'Pages', pages_path )
		] )
	end

	def my_menu
		css_menu('My', [
			link_to( 'Stuff',     mystuff_path ),
			link_to( 'Messages',  messages_path ),
			link_to( 'Profile',   user_path(current_user) ),
			link_to( 'Assets',    assets_path ),
			link_to( 'Downloads', downloads_path )
		] )
	end

	def legend
		legend_table = [ "<table id='legend'>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd private'>&nbsp;</div>" <<
			"<div class='row even private'>&nbsp;</div></td>" <<
			"<td class='value'>Private</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd public'>&nbsp;</div>" <<
			"<div class='row even public'>&nbsp;</div></td>" <<
			"<td class='value'>Public</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd otheruser'>&nbsp;</div>" <<
			"<div class='row even otheruser'>&nbsp;</div></td>" <<
			"<td class='value'>Other User</td></tr>" <<
			"</table>" ]
		css_menu('Legend',legend_table)
	end

	def downloads_legend
		legend_table = [ "<table id='legend'>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd success'>&nbsp;</div>" <<
			"<div class='row even success'>&nbsp;</div></td>" <<
			"<td class='value'>Success</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd failure'>&nbsp;</div>" <<
			"<div class='row even failure'>&nbsp;</div></td>" <<
			"<td class='value'>Failure</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd'>&nbsp;</div>" <<
			"<div class='row even'>&nbsp;</div></td>" <<
			"<td class='value'>Waiting</td></tr>" <<
			"</table>" ]
		css_menu('Legend',legend_table)
	end

	def assets_legend
		legend_table = [ "<table id='legend'>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd unused'>&nbsp;</div>" <<
			"<div class='row even unused'>&nbsp;</div></td>" <<
			"<td class='value'>Unused</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd sold'>&nbsp;</div>" <<
			"<div class='row even sold'>&nbsp;</div></td>" <<
			"<td class='value'>Sold</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd want'>&nbsp;</div>" <<
			"<div class='row even want'>&nbsp;</div></td>" <<
			"<td class='value'>Want</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd for_sale'>&nbsp;</div>" <<
			"<div class='row even for_sale'>&nbsp;</div></td>" <<
			"<td class='value'>For Sale</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd borrowed'>&nbsp;</div>" <<
			"<div class='row even borrowed'>&nbsp;</div></td>" <<
			"<td class='value'>Borrowed</td></tr>" <<
			"<tr><td class='color'>" <<
			"<div class='row odd'>&nbsp;</div>" <<
			"<div class='row even'>&nbsp;</div></td>" <<
			"<td class='value'>Normal</td></tr>" <<
			"</table>" ]
		css_menu('Legend',legend_table)
	end

	def asset_menu(asset)
		menu_items = [ 
			link_to( 'Edit', edit_asset_path(asset) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_asset_path(asset), :class => "confirm_destroy" )
		]
		css_menu('Asset',menu_items)
	end

	def assets_menu
		menu_items = [ 
			link_to( 'New Asset', new_asset_path ),
			link_to( 'Batch New Asset', batch_new_assets_path ),
			link_to( 'Export all as PDF', assets_path(:format => :pdf) ),
			link_to( 'Export all as TXT', assets_path(:format => :txt) ),
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) ),
			link_to( 'Edit These', params.merge({:action => 'stream_edit'}) ),
			"<hr/>",
			link_to( 'Categories', categories_path ),
			link_to( 'Creators', creators_path ),
			link_to( 'Locations', locations_path )
		]
		css_menu('Assets',menu_items)
	end

#	def stream_edit_assets
#		#	I tried to use form_for and form_tag and they produced empty forms.
#		#	I then tried adding concats and I ended up with 2 forms!
#		#	I'm sure that if I knew what I was doing, it would work, but I don't.
#		form = "<form action='#{stream_edit_assets_path}' method='post'>" <<
#			"<input type='hidden' name='authenticity_token' "<<
#				"value='#{if (protect_against_forgery?);form_authenticity_token();end}' />"
#
#		form << params.keys.reject{|k| ['action','controller'].include?(k) }.collect do |key|
#			if params[key].is_a?(Array)
#				params[key].collect{|v| hidden_field_tag( key+'[]', v, :id => nil ) }.join()
#			else
#				hidden_field_tag( key, params[key], :id => nil )
#			end
#		end.join()
#
#		form << "<input type='submit' value='Edit these' class='link' /></form>"
#		return form
#	end

	def blogs_menu
		menu_items = [ 
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) )
		]
		css_menu('Blogs',menu_items)
	end

	def blog_menu(blog)
		menu_items = [
			link_to( 'Export as TXT', blog_path(blog, :format => :txt) ),
			link_to( 'Export as PDF', blog_path(blog, :format => :pdf) )
		]
		menu_items.push(
			link_to( 'Add Entry', new_blog_entry_path(blog) ),
			link_to( 'Edit', edit_blog_path(blog) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_blog_path(blog), :class => "confirm_destroy" )
		) if editable?(blog)
		css_menu('Blog',menu_items)
	end

	def category_menu(category)
		menu_items = [ 
			link_to( 'Categories', categories_path ),
			link_to( 'Edit', edit_category_path(category) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_category_path(category), :class => "confirm_destroy" )
		]
		css_menu('Category',menu_items)
	end

	def creator_menu(creator)
		menu_items = [ 
			link_to( 'Creators', creators_path ),
			link_to( 'Edit', edit_creator_path(creator) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_creator_path(creator), :class => "confirm_destroy" )
		]
		css_menu('Creator',menu_items)
	end

	def download_menu(download)
		menu_items = [ 
			link_to( 'Downloads', downloads_path ),
			rebuild_download(download),
			link_to( 'Edit', edit_download_path(download) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_download_path(download), :class => "confirm_destroy" )
		]
		css_menu('Download',menu_items)
	end

	def rebuild_download(download)
		#	I tried to use form_for and form_tag and they produced empty forms.
		#	I then tried adding concats and I ended up with 2 forms!
		#	I'm sure that if I knew what I was doing, it would work, but I don't.
		return "<form action='#{download_path(download)}' method='post'>" <<
			"<input type='hidden' name='_method' value='put' />" <<
			"<input type='hidden' name='authenticity_token' "<<
				"value='#{if (protect_against_forgery?);form_authenticity_token();end}' />" <<
			"<input type='hidden' name='download[started_at]' value='' />" <<
			"<input type='hidden' name='download[completed_at]' value='' />" <<
			"<input type='hidden' name='download[status]' value='' />" <<
			"<input type='submit' name='' value='Rebuild' class='link' />" <<
			"</form>"
	end

	def entry_menu(entry)
		menu_items = [ link_to( 'Blog', blog_path(entry.blog) ) ]
		menu_items.push(link_to( 'Edit', edit_entry_path(entry) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_entry_path(entry), :class => "confirm_destroy" )
		) if editable?(entry)
		css_menu('Entry',menu_items)
	end

	def lists_menu
		menu_items = [ 
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) )
		]
		css_menu('Lists',menu_items)
	end

	def list_menu(list)
		menu_items = [ 
			link_to( 'Convert to Note', convert_to_note_list_path(list) ),
			link_to( 'Copy', copy_list_path(list) ),
			link_to( 'Export as TXT', list_path(list, :format => :txt) ),
			link_to( 'Export as PDF', list_path(list, :format => :pdf) ) ]
		menu_items.push(
			link_to( 'Edit', edit_list_path(list) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_list_path(list), :class => "confirm_destroy" )
		) if editable?(list)
		css_menu('List',menu_items)
	end

	def location_menu(location)
		menu_items = [ 
			link_to( 'Locations', locations_path ),
			link_to( 'Edit', edit_location_path(location) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_location_path(location), :class => "confirm_destroy" )
		]
		css_menu('Location',menu_items)
	end

	def notes_menu
		menu_items = [ 
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) )
		]
		css_menu('Notes',menu_items)
	end

	def note_menu(note)
		menu_items = [
			link_to( 'Convert to List', convert_to_list_note_path(note) ),
			link_to( 'Copy', copy_note_path(note) ),
			link_to( 'Export as TXT', note_path(note, :format => :txt) ),
			link_to( 'Export as PDF', note_path(note, :format => :pdf) ),
			link_to( 'Decrypt', "javascript:void(0);", :id => 'decrypt' ),
			link_to( 'Parse And Plot', "javascript:void(0);", :id => 'parse_and_plot' )
#			link_to_function( 'Decrypt', "Decrypt_ID('note_body')" ),
#			link_to_function( 'Parse And Plot', 'parse_and_plot()' ) 
		]
		menu_items.push(
			link_to( 'Edit', edit_note_path(note) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_note_path(note), :class => "confirm_destroy" )
		) if editable?(note)
		css_menu('Note',menu_items)
	end

	def edit_note_menu(note)
		menu_items = [
#			link_to_function( 'Encrypt', "Encrypt_ID('note_body')" ),
#			link_to_function( 'Decrypt', "Decrypt_ID('note_body')" ),
			link_to( 'Encrypt', "javascript:void(0);", :id => 'encrypt' ),
			link_to( 'Decrypt', "javascript:void(0);", :id => 'decrypt' ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_note_path(note), :class => "confirm_destroy" )
		]
		css_menu('Note',menu_items)
	end

	def page_menu(page)
return if page.nil?
		menu_items = [
			link_to( 'Edit', edit_page_path(page) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_page_path(page), :class => "confirm_destroy" )
		]
		css_menu('Page',menu_items)
	end

	def resumes_menu
		menu_items = [ 
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) )
		]
		css_menu('Resumes',menu_items)
	end

	def resume_menu(resume)
		menu_items = [
			link_to( 'Export as TXT', resume_path(resume, :format => :txt) ),
			link_to( 'Export as PDF', resume_path(resume, :format => :pdf) ) ]
		menu_items.push(
			link_to( 'Edit', edit_resume_path(resume) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_resume_path(resume), :class => "confirm_destroy" )
		) if editable?(resume)
		css_menu('Resume',menu_items)
	end


	def stop_menu(stop)
		menu_items = [ link_to( 'Trip', trip_path(stop.trip) ) ]
		menu_items.push(
			link_to( 'Edit', edit_stop_path(stop) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_stop_path(stop), :class => "confirm_destroy" )
		) if editable?(stop)
		css_menu('Stop',menu_items)
	end

	def trips_menu
		menu_items = [ 
			link_to( 'Export these as PDF', params.merge({:format => :pdf}) ),
			link_to( 'Export these as TXT', params.merge({:format => :txt}) )
		]
		css_menu('Trips',menu_items)
	end

	def trip_menu(trip)
		menu_items = [
			link_to( 'Export as TXT', trip_path(trip, :format => :txt) ),
			link_to( 'Export as PDF', trip_path(trip, :format => :pdf) )
		]
		menu_items.push(
			link_to( 'Edit', edit_trip_path(trip) ),
			"<hr/>",
			link_to( 'Destroy', confirm_destroy_trip_path(trip), :class => "confirm_destroy" )
		) if editable?(trip)
		css_menu('Trip',menu_items)
	end

	def user_menu(user)
		menu_items = [ 
			link_to( 'Edit', edit_user_path(user) ),
			link_to( 'Change Password', change_password_path ) ]
		css_menu('Profile',menu_items)
	end

	def forums_menu
	end
	def forum_menu(forum)
	end
	def topics_menu
	end
	def topic_menu(topic)
	end
	def posts_menu
	end
	def post_menu(post)
	end

end

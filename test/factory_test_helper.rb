module FactoryTestHelper

	def admin_role
		Role.find_or_create_by_name('administrator')
	end

	def active_user(options={})
		u = Factory(:user, options)
		u.send(:activate!)
		u
	end

	def admin_user(options={})
		u = active_user(options)
		u.roles << admin_role
		u
	end

	def board_with_magnets(magnets_count=3,options={})
		board = Factory(:board)
		magnets_count.times { Factory(:magnet, :board => board) }
		board
	end

	def list_with_items(items_count=3,options={})
		list = Factory(:public_list)
		items_count.times { Factory(:item, {:list => list, :completed => false}.merge(options)) }
		items_count.times { Factory(:item, {:list => list, :completed => true}.merge(options)) }
		list
	end

	def blog_with_entries(entries_count=3,options={})
		blog = Factory(:blog)
		entries_count.times { entry_with_comments(blog) }
		blog
	end

	def blog_with_entries_with_photos_and_comments(entries_count=3,options={})
		blog = Factory(:blog)
		entries_count.times { entry_with_photos_and_comments(blog) }
		blog
	end

	def entry_with_photos_and_comments(blog,photos_count=3,comments_count=3,options={})
		entry = Factory(:entry, :blog => blog)
		#	prawn doesn't work with GIF so I created a PNG
		photos_count.times { entry.photos << Factory(:photo, :file => upload(f('drag.png')) ) }
		comments_count.times { Factory(:comment, :commentable => entry) }
#	doesn't work
#		comments_count.times { entry.comments << Factory(:comment) }
		entry
	end

	def entry_with_photos(blog,photos_count=3,options={})
		entry = Factory(:entry, :blog => blog)
		#	prawn doesn't work with GIF so I created a PNG
		photos_count.times { entry.photos << Factory(:photo, :file => upload(f('drag.png')) ) }
		entry
	end

	def entry_with_comments(blog,comments_count=3,options={})
		entry = Factory(:entry, :blog => blog)
		comments_count.times { Factory(:comment, :commentable => entry) }
		entry
	end

	def trip_with_stops(stops_count=3,options={})
		trip = Factory(:trip)
#		stops_count.times { Factory(:stop, :trip => trip) }
		stops_count.times { stop_with_comments(trip) }
		trip
	end

	def trip_with_stops_with_photos_and_comments(stops_count=3,options={})
		trip = Factory(:trip)
		stops_count.times { stop_with_photos_and_comments(trip) }
		trip
	end

	def stop_with_photos_and_comments(trip,photos_count=3,comments_count=3,options={})
		stop = Factory(:stop, :trip => trip)
		#	prawn doesn't work with GIF so I created a PNG
		photos_count.times { stop.photos << Factory(:photo, :file => upload(f('drag.png')) ) }
		comments_count.times { Factory(:comment, :commentable => stop) }
#	doesn't work
#		comments_count.times { entry.comments << Factory(:comment) }
		stop
	end

	def stop_with_comments(trip,comments_count=3,options={})
		stop = Factory(:stop, :trip => trip)
		comments_count.times { Factory(:comment, :commentable => stop) }
		stop
	end

	def stop_with_photos(trip,photos_count=3,options={})
		stop = Factory(:stop, :trip => trip)
		photos_count.times { stop.photos << Factory(:photo, :file => upload(f('drag.png')) ) }
		stop
	end

	def resume_with_components(options={})
		resume = Factory(:public_resume)
		3.times { Factory(:affiliation, :resume => resume) }
		3.times { Factory(:publication, :resume => resume) }
		3.times { Factory(:skill, :resume => resume) }
		3.times { Factory(:job, :resume => resume) }
		3.times { Factory(:school, :resume => resume) }
		3.times { Factory(:language, :resume => resume) }
		resume
	end

#	def location_with_assets(options={})
#		location = Factory(:location)
#		3.times { Factory( :asset, :location_names => location.name ) }
#		location
#	end
#
#	def creator_with_assets(options={})
#		creator = Factory(:creator)
#		3.times { Factory( :asset, :creator_names => creator.name ) }
#		creator
#	end
#
#	def category_with_assets(options={})
#		category = Factory(:category)
#		3.times { Factory( :asset, :category_names => category.name ) }
#		category
#	end

end

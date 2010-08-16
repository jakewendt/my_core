module PrawnExtension
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
      include InstanceMethods
    end
  end

  module ClassMethods
  end

  module InstanceMethods

		def assets(assets=[])
			if assets.length > 0
				self.start_new_page
				self.text "Assets", :size => 20, :style => :bold, :align => :center
#				notes.each { |note| self.text note.title }
				assets.each { |asset| self.asset(asset) }
			end
		end

		def asset(asset)
			self.text asset.title, :size => 20, :style => :bold, :align => :center
			self.move_down(10)
			unless asset.description.blank?
				self.text asset.description, :size => 12
				self.move_down(10)
			end
#			self.text "Tag names: #{note.tag_names}", :size => 12, :align => :center
#			self.text "Created on #{note.created_at.to_s(:basic)}", :size => 12, :align => :center
#			self.text "Last updated on #{note.updated_at.to_s(:basic)}", :size => 12, :align => :center
		end

		def notes(notes=[])
			if notes.length > 0
				self.start_new_page
				self.text "Notes", :size => 20, :style => :bold, :align => :center
				notes.each { |note| self.text note.title }
				notes.each { |note| self.note(note) }
			end
		end

		def note(note)
			self.start_new_page
			self.text note.title, :size => 20, :style => :bold, :align => :center
			self.move_down(10)
			self.text note.body, :size => 12
			self.move_down(10)
			self.text "Tag names: #{note.tag_names}", :size => 12, :align => :center
			self.text "Created on #{note.created_at.to_s(:basic)}", :size => 12, :align => :center
			self.text "Last updated on #{note.updated_at.to_s(:basic)}", :size => 12, :align => :center
		end

		def lists(lists=[])
			if lists.length > 0
				self.start_new_page
				self.text "Lists", :size => 20, :style => :bold, :align => :center
				lists.each { |list| self.text list.title }
				lists.each { |list| self.list(list) }
			end
		end

		def list(list)
			self.start_new_page 
			self.text list.title, :size => 20, :style => :bold, :align => :center
			self.text "\nIncomplete:\n\n", :size => 18
			list.items.incomplete.each { |i| 
				self.text "\t"*3+i.content, :size => 14 }
			self.text "\nComplete:\n\n", :size => 18
			list.items.complete.each        { |i| 
				self.text "\t"*3+i.content, :size => 14 }
			self.move_down(10)
			unless list.description.blank?
				self.text list.description, :size => 12
				self.move_down(10)
			end
			self.text "Tag names: #{list.tag_names}", :size => 12, :align => :center
			self.text "Created on #{list.created_at.to_s(:basic)}", :size => 12, :align => :center
			self.text "Last updated on #{list.updated_at.to_s(:basic)}", :size => 12, :align => :center
		end

		def blogs(blogs=[])
			if blogs.length > 0
				self.start_new_page
				self.text "Blogs", :size => 20, :style => :bold, :align => :center
				blogs.each { |blog| self.text blog.title }
				blogs.each { |blog| self.blog(blog) }
			end
		end

		def blog(blog)
			self.start_new_page 
			self.text blog.title, :size => 20, :style => :bold, :align => :center
			self.move_down(10)
			unless blog.description.blank?
				self.text blog.description, :size => 12
				self.move_down(10)
			end
			self.text "Tag names: #{blog.tag_names}", :size => 12, :align => :center
			self.text "Created on #{blog.created_at.to_s(:basic)}", :size => 12, :align => :center
			self.text "Last updated on #{blog.updated_at.to_s(:basic)}", :size => 12, :align => :center
			self.move_down(10)
			self.entries(blog.entries)
		end

		def trips(trips=[])
			if trips.length > 0
				self.start_new_page
				self.text "Trips", :size => 20, :style => :bold, :align => :center
				trips.each { |trip| self.text trip.title }
				trips.each { |trip| self.trip(trip) }
			end
		end

		def trip(trip)
			self.start_new_page 
			self.text trip.title, :size => 20, :style => :bold, :align => :center
			self.move_down(10)
			unless trip.description.blank?
				self.text trip.description, :size => 12
				self.move_down(10)
			end
			self.text "Tag names: #{trip.tag_names}", 
				:size => 12, :align => :center
			self.text "Created on #{trip.created_at.to_s(:basic)}", 
				:size => 12, :align => :center
			self.text "Last updated on #{trip.updated_at.to_s(:basic)}", 
				:size => 12, :align => :center
			self.move_down(10)
			self.stops(trip.stops)
		end

		def stops(stops=[])
			stops.each { |stop| self.stop(stop) }
		end

		def stop(stop)
			self.text "#{stop.title} (created on #{stop.created_at.to_s(:basic)})", :size => 18, :style => :bold
			self.move_down(20)
			unless stop.description.blank?
				self.text stop.description||'', :size => 16
				self.move_down(20)
			end
			self.photos(stop.photos)
			self.comments(stop.comments)
		end

		def entries(entries=[])
			entries.each { |entry| self.entry(entry) }
		end

		def entry(entry)
			self.text "#{entry.title} (created on #{entry.created_at.to_s(:basic)})", :size => 18, :style => :bold
			self.move_down(20)
			self.text entry.body, :size => 16
			self.move_down(20)
			self.photos(entry.photos)
			self.comments(entry.comments)
		end

		def photos(photos=[])
			photos.each { |photo| self.photo(photo) }
		end

		def photo(photo)
			unless photo.file.blank?
				if File.exists?(photo.file)
					self.start_new_page
					#	self.image "#{RAILS_ROOT}/public#{ActionController::Base.helpers.url_for_file_column(photo, 'file')}",
					self.image photo.file, :position => :center, :width => 550
					self.move_down(10)
					#	self.text "#{RAILS_ROOT}/public#{ActionController::Base.helpers.url_for_file_column(photo, 'file')}"
					self.text photo.file
					self.move_down(10)
				else
					self.text "#{photo.file} not found."
					self.move_down(10)
				end
#				self.text "http://#{request.host_with_port}#{ActionController::Base.helpers.url_for_file_column(photo, 'file')}"
			end
			unless photo.caption.blank?
				self.text photo.caption
				self.move_down(10)
			end
		end

		def comments(comments=[])
			comments.each { |comment| self.comment(comment) }
		end

		def comment(comment)
			self.text "On #{comment.created_at.to_s(:long)}, #{comment.user.login} said ... ", :size => 14
			self.move_down(20)
			unless comment.body.blank?
				self.text comment.body, :size => 12
				self.move_down(20)
			end
		end

		def resumes(resumes=[])
		end
		def resume(resume)
		end

	end
end
Prawn::Document.send( :include, PrawnExtension )

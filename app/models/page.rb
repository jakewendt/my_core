class Page < ActiveRecord::Base
	validates_length_of :path,  :minimum => 4
	validates_length_of :title, :minimum => 4
	validates_length_of :body,  :minimum => 4
	validates_uniqueness_of :path

	attr_accessible :path, :title, :body

	acts_as_list

	def self.by_title(title)
		find(:first,
			:conditions => {
				:title => title 
			}
		)
	end

	def self.by_path(path)
		find(:first,
			:conditions => {
				:path => path 
			}
		)
	end

	def self.find_all
#	caching messes things up when adding new pages and editing positions
#		@all_pages ||= find(:all, :order => :position)
		find(:all, :order => :position)
	end

	def self.help_pages
#		@help_pages ||= find(:all, 
		find(:all, 
			:conditions => [ "path LIKE ?","/help/%" ],
			:order => :position
		)
	end

	def self.non_help_pages
#		@non_help_pages ||= find(:all, 
		find(:all, 
			:conditions => [ "path NOT LIKE ?","/help/%" ],
			:order => :position
		)
	end

end

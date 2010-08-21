class Item < ActiveRecord::Base
	belongs_to :list, :counter_cache => true

	validates_presence_of :list_id

	attr_accessible :content, :completed

	acts_as_list :scope => :list

	delegate :user, :to => :list

	before_save   :update_completed_at
	before_update :update_list_items_count
	after_create  :increment_list_complete_items_count
	after_destroy :decrement_list_complete_items_count

	before_save    :update_list_updated_at
#	definitely not needed as the items_count will be updated triggering updated_at update
#	before_destroy :update_list_updated_at
#
#	This is a bit unnecessary as the manual updating of the *complete_items_count updates updated_at.
#	This is triggered by any save including reordering.
#	This is also NOT triggered when just the content changes!
#	The items_count counter_cache updating of the list does NOT seem to do this.
#
	def update_list_updated_at
		#	force updating of updated_at
#		self.list.update_attribute(:updated_at, Time.now)
		self.list.updated_at = Time.now
		self.list.save if self.list.changed?
	end

	def decrement_list_complete_items_count
		if self.completed
			self.list.decrement!(:complete_items_count)
		else
			self.list.decrement!(:incomplete_items_count)
		end
	end

	def increment_list_complete_items_count
		if self.completed	#	need to check if completed because of copy function
			self.list.increment!(:complete_items_count)
		else
			self.list.increment!(:incomplete_items_count)
		end
	end

	def update_list_items_count
		if self.completed_changed?
			if self.completed
				self.list.increment!(:complete_items_count)
				self.list.decrement!(:incomplete_items_count)
			else
				self.list.decrement!(:complete_items_count)
				self.list.increment!(:incomplete_items_count)
			end
		end
	end

	def update_completed_at
		if completed_at && !completed
			update_attribute(:completed_at, nil)
		elsif completed_at.nil? && completed
			update_attribute(:completed_at, Time.now)
		end
	end

	named_scope :complete,   :conditions => { :completed => true }
	named_scope :incomplete, :conditions => { :completed => false }

end

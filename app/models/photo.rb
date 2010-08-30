class Photo < ActiveRecord::Base

#
#	could remove :stop_id
#


	has_many_polymorphs :photoables, :from => [:entries, :stops] #, :dependent => :destroy

#	belongs_to :user, :counter_cache => true
#	validates_presence_of :user_id
	acts_as_ownable

	file_column :file

	attr_accessible :file, :file_temp, :caption

	simply_commentable
#	acts_as_commentable
end

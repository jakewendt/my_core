class Stop < ActiveRecord::Base

#
#	Could remove :images_count
#

	belongs_to :trip, :counter_cache => true

	acts_as_list :scope => :trip

	acts_as_commentable

	delegate :user, :to => :trip

	validates_presence_of :trip_id
	validates_length_of :title, :in => 4..100
	validates_numericality_of :lat, :lng

	attr_accessible :title, :description, :lat, :lng

end

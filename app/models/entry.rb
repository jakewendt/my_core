class Entry < ActiveRecord::Base
	belongs_to :blog, :counter_cache => true

	validates_presence_of :blog_id
	validates_length_of :title, :in => 4..100
	validates_length_of :body, :minimum => 4

	attr_accessible :title, :body, :created_at, :created_at_string
	stringify_time :created_at

	simply_commentable
#	acts_as_commentable

	delegate :user, :to => :blog

end

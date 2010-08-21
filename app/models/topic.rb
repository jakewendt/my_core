class Topic < ActiveRecord::Base
	belongs_to :forum, :counter_cache => true 
	has_many :posts, :dependent => :destroy

#	belongs_to :user , :counter_cache => true
#	validates_presence_of :user_id
	acts_as_ownable

	validates_presence_of :forum_id
	validates_length_of :name, :in => 4..100

	attr_accessible :name
end

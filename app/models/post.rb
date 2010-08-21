class Post < ActiveRecord::Base
	belongs_to :topic, :counter_cache => true 

#	belongs_to :user,	:counter_cache => true 
#	validates_presence_of :user_id
	acts_as_ownable

	validates_length_of :body, :in => 4..10000 

	attr_accessible :body

end

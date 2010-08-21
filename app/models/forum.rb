class Forum < ActiveRecord::Base
	validates_length_of :name, :in => 4..100
	validates_length_of :description, :in => 4..1000 

	has_many :topics, :dependent => :destroy
	has_many :posts,	:through => :topics

	attr_accessible :name, :description
end

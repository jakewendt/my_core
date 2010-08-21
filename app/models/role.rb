class Role < ActiveRecord::Base
	has_and_belongs_to_many :users

	validates_uniqueness_of :name
	validates_length_of :name, :in => 4..20

	attr_accessible :name
end

class Level < ActiveRecord::Base
	has_many :languages
	has_many :skills

	validates_presence_of :name
	validates_presence_of :value
end

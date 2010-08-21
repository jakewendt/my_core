class Trip < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Created_At Updated_At )

	acts_as_taggable
	acts_as_ownable

	has_many :stops, :dependent => :destroy, :order => :position
	has_many :photoables_photos, :through => :stops

	validates_length_of :title, :within => 4..100
	validates_numericality_of :lat, :lng
	validates_numericality_of :zoom, :only_integer => true

	attr_accessible :title, :description, :lat, :lng, :zoom, :public

	def self.to_s	 # default would be "Trip"
		"Travel Blog"
	end

end

class Board < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Created_At Updated_At )

	acts_as_taggable
	acts_as_ownable

	has_many :magnets, :dependent => :destroy, :order => :position
	accepts_nested_attributes_for :magnets, :allow_destroy => true
	attr_accessible :magnets_attributes

	validates_presence_of :title
	validates_length_of	 :title, :within => 4..40

	attr_accessible :title, :public

	def self.to_s	 # default would be "Board"
		"Magnetic Poetry Board"
	end

end

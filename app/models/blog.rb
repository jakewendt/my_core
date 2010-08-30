class Blog < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Created_At Updated_At )

#	acts_as_taggable
	simply_taggable
	acts_as_ownable

	has_many :entries, :dependent => :destroy, :order => 'created_at DESC'
	has_many :photoables_photos, :through => :entries

	validates_length_of :title, :in => 4..100

	attr_accessible :title, :description, :public

end

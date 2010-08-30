class Note < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Created_At Updated_At )

#	acts_as_taggable
	simply_taggable
	acts_as_ownable

	validates_length_of :title, :minimum => 3

	attr_accessible :title, :body, :public, :hide, :textilize

	named_scope :not_hidden, :conditions => { :hide => false }

end

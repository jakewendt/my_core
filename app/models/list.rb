class List < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Items_Count Complete_Items_Count Incomplete_Items_Count Created_At Updated_At )

#	acts_as_taggable
	simply_taggable
	acts_as_ownable

	has_many :items, :dependent => :destroy, :order => :position

	#	I only use incomplete items on the list edit form.
	has_many :incomplete_items, :dependent => :destroy, 
		:order => :position, :conditions => { :completed => false }, :class_name => "Item"
	accepts_nested_attributes_for :incomplete_items, :allow_destroy => true
	attr_accessible :incomplete_items_attributes

	validates_length_of :title, :in => 3..100

	attr_accessible :title, :description, :public, :hide

	named_scope :hidden,     :conditions => { :hide => true }
	named_scope :not_hidden, :conditions => { :hide => false }

end

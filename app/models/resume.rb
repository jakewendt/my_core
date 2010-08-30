class Resume < ActiveRecord::Base
	include CommonSearch
	SORTABLE_COLUMNS = %w( Title Created_At Updated_At )

	has_many	 :skills,	:dependent => :destroy, :order => :position
	has_many	 :jobs,		:dependent => :destroy, :order => 'start_date DESC'
	has_many	 :schools, :dependent => :destroy, :order => 'start_date DESC'
	has_many	 :affiliations, :dependent => :destroy, :order => 'start_date DESC'
	has_many	 :publications, :dependent => :destroy, :order => 'date DESC'
	has_many	 :languages, :dependent => :destroy, :order => :position

	accepts_nested_attributes_for :skills, :jobs, :schools, :affiliations, :publications, :languages,
		:allow_destroy => true
	attr_accessible :skills_attributes, :jobs_attributes, :schools_attributes,
		:affiliations_attributes, :publications_attributes, :languages_attributes

#	acts_as_taggable
	simply_taggable
	acts_as_ownable

	validates_length_of :title, :in => 4..100

	attr_accessible :title, :objective, :summary, :other, :public

end

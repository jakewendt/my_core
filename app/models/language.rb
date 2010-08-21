class Language < ActiveRecord::Base
	acts_as_resume_component
	belongs_to :level

	validates_presence_of :level_id
	validates_presence_of :name

	attr_accessible :name, :level_id

	acts_as_list :scope => :resume

end

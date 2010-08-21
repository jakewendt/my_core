class Publication < ActiveRecord::Base
	acts_as_resume_component

	validates_presence_of :contribution
	validates_presence_of :name
	validates_presence_of :title
#	validates_presence_of :date
	validates_presence_of :date_string

#	attr_accessible :date, :date_string, :name, :title, :contribution, :url
	attr_accessible :date_string, :name, :title, :contribution, :url
	
	stringify_date :date

	acts_as_list :scope => :resume

	def validate
#		errors.add(:date, "is invalid") if date_invalid?
		errors.add(:date_string, "is invalid") if date_invalid?
	end

end

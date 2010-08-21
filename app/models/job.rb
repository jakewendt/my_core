class Job < ActiveRecord::Base
	acts_as_resume_component :default => :title

	validates_presence_of :title
#	validates_presence_of :start_date
	validates_presence_of :start_date_string
	validates_presence_of :company
	validates_presence_of :location

	stringify_date :start_date, :end_date

#	attr_accessible :start_date, :end_date, :start_date_string, :end_date_string, 
	attr_accessible :start_date_string, :end_date_string, 
		:title, :company, :location, :description

	def validate
#		errors.add(:start_date, "is invalid") if start_date_invalid?
#		errors.add(:end_date,	"is invalid") if end_date_invalid?
		errors.add(:start_date_string, "is invalid") if start_date_invalid?
		errors.add(:end_date_string,	"is invalid") if end_date_invalid?
	end

	def end_date_to_s
		if end_date.blank?
			"Present"
		else
			end_date.to_s(:month_year)
		end
	end

end

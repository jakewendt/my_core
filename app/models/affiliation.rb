class Affiliation < ActiveRecord::Base
	acts_as_resume_component :default => :organization

#	validates_presence_of :start_date
	validates_presence_of :start_date_string
	validates_presence_of :organization
	validates_presence_of :relationship

#	attr_accessible :start_date, :start_date_string, :end_date, :end_date_string,
	attr_accessible :start_date_string, :end_date_string,
		:organization, :relationship

	stringify_date :start_date, :end_date

	acts_as_list :scope => :resume

#	before_validation_on_create :set_default_attributes
#
#	def set_default_attributes
#		organization = "Organization" if organization.blank?
#		relationship = "Relationship" if relationship.blank?
#	end

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

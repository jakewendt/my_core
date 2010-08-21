class Skill < ActiveRecord::Base
	acts_as_resume_component
	belongs_to :level

	validates_presence_of :level_id
#	validates_presence_of :start_date
	validates_presence_of :start_date_string
	validates_length_of	 :name, :in => 1..32

	stringify_date :start_date, :end_date
	acts_as_list :scope => :resume

#	attr_accessible :level_id, :start_date, :end_date, :name, :start_date_string, :end_date_string
	attr_accessible :level_id, :name, :start_date_string, :end_date_string
	attr_accessor :years_experience

	def validate
#		errors.add(:start_date, "is invalid") if start_date_invalid?
#		errors.add(:end_date,	"is invalid") if end_date_invalid?
		errors.add(:start_date_string, "is invalid") if start_date_invalid?
		errors.add(:end_date_string,	"is invalid") if end_date_invalid?
	end

	def years_experience
		last = end_date || Date.today
		experience = (last.year - start_date.year) + (last.month - start_date.month)/12.0
		(experience * 10).to_i / 10.0
	end

	def end_date_to_s
		if end_date.blank?
			"Present"
		else
			end_date.to_s(:month_year)
		end
	end

end

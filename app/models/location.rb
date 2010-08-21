class Location < ActiveRecord::Base
	has_many :location_taggings, :dependent => :destroy
	has_many :assets, :through => :location_taggings

	belongs_to :user
	validates_presence_of :user_id
#	create a User.locations_count first
#	acts_as_ownable

	before_save :squish_name

	validates_presence_of :name
	validates_length_of :name, :minimum => 1
	validates_uniqueness_of :name, :scope => :user_id
	validates_format_of :name, :with => /^[^!].*/i, :message => "can't begin with a bang!"

	class MultipleLocationsFound < StandardError
		attr_reader :message;
		def initialize(message="Multiple locations found")
			@message = message
		end
	end

	def squish_name
		name.squish!
	end

	def self.find_or_create(conditions={})
		locations = find(:all, :conditions => conditions)
		case locations.length
			when 0 
#				puts "  Creating new location."
				self.create!(conditions)
			when 1 
#				puts "  Found existing location."
				locations[0]
#			else raise "Multiple locations found matching #{conditions.inspect}."
			else raise MultipleLocationsFound.new("Multiple locations found matching #{conditions.inspect}.")
		end
	end

end

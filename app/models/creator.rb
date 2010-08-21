class Creator < ActiveRecord::Base
	has_many :creator_taggings, :dependent => :destroy
	has_many :assets, :through => :creator_taggings

	belongs_to :user
	validates_presence_of :user_id
#	create a User.creators_count first
#	acts_as_ownable

	before_save :squish_name

	validates_presence_of :name
	validates_length_of :name, :minimum => 1
	validates_uniqueness_of :name, :scope => :user_id
	validates_format_of :name, :with => /^[^!].*/i, :message => "can't begin with a bang!"

	class MultipleCreatorsFound < StandardError
		attr_reader :message;
		def initialize(message="Multiple creators found")
			@message = message
		end
	end

	def squish_name
		name.squish!
	end

	def self.find_or_create(conditions={})
		creators = find(:all, :conditions => conditions)
		case creators.length
			when 0 
#				puts "  Creating new location."
				self.create!(conditions)
			when 1 
#				puts "  Found existing location."
				creators[0]
#			else raise "Multiple creators found matching #{conditions.inspect}."
			else raise MultipleCreatorsFound.new("Multiple creators found matching #{conditions.inspect}.")
		end
	end

end

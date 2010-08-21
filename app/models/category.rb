class Category < ActiveRecord::Base
	has_many :category_taggings, :dependent => :destroy
	has_many :assets, :through => :category_taggings

	belongs_to :user
	validates_presence_of :user_id
#	doesn't work as User does not have a categories_count (yet)
#	acts_as_ownable

	before_save :squish_name

	validates_presence_of :name
	validates_length_of :name, :minimum => 1
	validates_uniqueness_of :name, :scope => :user_id
	validates_format_of :name, :with => /^[^!].*/i, :message => "can't begin with a bang!"

	class MultipleCategoriesFound < StandardError
		attr_reader :message;
		def initialize(message="Multiple categories found")
			@message = message
		end
	end

	def squish_name
		name.squish!
	end

	def self.find_or_create(conditions={})
		categories = find(:all, :conditions => conditions)
		case categories.length
			when 0 
#				puts "  Creating new category."
				self.create!(conditions)
			when 1 
#				puts "  Found existing category."
				categories[0]
#			else raise "Multiple categories found matching #{conditions.inspect}."
			else raise MultipleCategoriesFound.new("Multiple categories found matching #{conditions.inspect}.")
		end
	end

end

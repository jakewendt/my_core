# ActsAsTaggable
module Jake
	module Acts #:nodoc:
		module Taggable #:nodoc:
			def self.included(base)
				base.extend(ClassMethods)
			end

			module ClassMethods
				def acts_as_taggable
					# include InstanceMethods
					# extend SingletonMethods
					include Jake::Acts::Taggable::InstanceMethods
					extend  Jake::Acts::Taggable::SingletonMethods

					has_many :taggings, :as => :taggable, :dependent => :destroy
					has_many :tags, :through => :taggings
					attr_writer :tag_names
					attr_accessible :tag_names
					after_save :assign_tags

				end
			end

			#	class methods like a find or something
			module SingletonMethods
			end

			module InstanceMethods

				def tag_names
					@tag_names || tags.map(&:name).join(', ')
				end

			private
	
				def assign_tags
					if @tag_names
						self.tags = @tag_names.names_to_array.map do |name|
							Tag.find_or_create({
								:name => name.squish,
								:user_id => self.user_id
							}) if !name.blank?
						end
					end
				end

			end 
		end
	end
end

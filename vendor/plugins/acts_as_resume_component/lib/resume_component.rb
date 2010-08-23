module ResumeComponent

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def acts_as_resume_component(*args)
			options = args.extract_options!

			cattr_accessor :default_field
			self.default_field = ( options[:default].blank? ) ? :name : options[:default] 

			include ResumeComponent::InstanceMethods
			extend  ResumeComponent::SingletonMethods
			validates_presence_of :resume_id
			belongs_to :resume, :counter_cache => true
			delegate :user, :to => :resume

			#	this will cause the resume's updated_at to be updated
			#	for every component it has on save.  Irritating.
			after_save    :update_resume_updated_at
			after_destroy :update_resume_updated_at
		end

	end

	module SingletonMethods

	end

	module InstanceMethods
		#	this default crap is to make testing easier
		def default=(new_value)
			self.send("#{self.class.send(:default_field)}=",new_value)
		end

		def default
			self.send(self.class.send(:default_field))
		end

		def update_resume_updated_at
#			self.resume.update_attribute(:updated_at, Time.now)
#	try to minimize the number of saves
			self.resume.updated_at = Time.now
			self.resume.save if self.resume.changed?
		end

	end

end
#ActiveRecord::Base.send( :include, ResumeComponent )

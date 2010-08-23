module ActsAsOwnable

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def acts_as_ownable
			include ActsAsOwnable::InstanceMethods
			extend  ActsAsOwnable::SingletonMethods

			belongs_to :user, :counter_cache => true
			validates_presence_of :user_id
			named_scope :public_and_mine, lambda { |*args| { 
				:conditions => ["public is true OR #{table_name}.user_id = ?", args.first||0] 
			} }

		end

	end

	module SingletonMethods
	end

	module InstanceMethods
	end

end

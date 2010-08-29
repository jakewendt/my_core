module ArrayExtension
	def self.included(base)
		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end
                
	module ClassMethods
	end
                
	module InstanceMethods

		#	destructive!
		def positive_filters!
			self.delete_if{|s|
				s.index("!") == 0		#	select only those that DO NOT start with a "!"
			}.uniq
		end

		#	destructive!
		def negative_filters!
			self.delete_if{|s|
				s.index("!") != 0		#	select only those that start with a "!"
			}.map{|s|
				s.slice(1..-1)			#	remove the "!"
			}.delete_if{ |s|
				s.blank?						#	ensure that filter wasn't just a "!"
			}.uniq
		end

		def positive_filters
			self.find_all{|s|
				s.index("!") != 0		#	select only those that DO NOT start with a "!"
			}.uniq
		end

		def negative_filters
			self.find_all{|s|
				s.index("!") == 0		#	select only those that start with a "!"
			}.map{|s|
				s.slice(1..-1)			#	remove the "!"
			}.delete_if{ |s|
				s.blank?						#	ensure that filter wasn't just a "!"
			}.uniq
		end

#	function exists in 1.9
		def each_cons(sub_size,&block)
			if self.length <= sub_size
				[self + Array.new(sub_size - self.length)]
#				[self.push(nil*(sub_size - self.length))]
			else
				#	[1,2,3,4].each_cons(3) => [[1,2,3],[2,3,4]]
				#	[1,2,3,4,5].each_cons(2) => [[1,2],[2,3],[3,4],[4,5]]
				out = []
				(self.length-(sub_size-1)).times do |i|
					out.push self.slice(i,sub_size)
				end
				out
			end
		end if RUBY_VERSION < '1.9'

	end
end
Array.send(:include, ArrayExtension)

module StringExtension
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
      include InstanceMethods
    end
  end

  module ClassMethods
  end

  module InstanceMethods

		#	>> "Here , There , Everywhere ,  HERE ".names_to_array
		#	=> ["Here", "There", "Everywhere"]
		def names_to_array
			seen = Hash.new(0)
			self.split(',').delete_if{ |s|
				s.blank?
			}.map{ |s|
				s.squish
			}.delete_if{ |s|
				( seen[s.downcase] += 1 ) > 1
			}
#
#	unfortunately, uniq is case sensitive
#
#			}.uniq
		end

		def positive_filters
#			self.names_to_array.delete_if{|s|
#				s.index("!") == 0		#	select only those that DO NOT start with a "!"
#			}
			self.names_to_array.positive_filters
		end

		def negative_filters
#			self.names_to_array.delete_if{|s|
#				s.index("!") != 0		#	select only those that start with a "!"
#			}.map{|s|
#				s.slice(1..-1)			#	remove the "!"
#			}.delete_if{ |s|
#				s.blank?						#	ensure that filter wasn't just a "!"
#			}
			self.names_to_array.negative_filters
		end

  end

end
String.send( :include, StringExtension )

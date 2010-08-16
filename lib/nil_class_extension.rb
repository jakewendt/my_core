module NilClassExtension
  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
      include InstanceMethods
    end
  end

  module ClassMethods
  end

  module InstanceMethods

#		def split(*args)
#			[]
#		end

		#	nice for when expecting an array like params[:tags].empty?
		#	so don't have to params[:tags] && params[:tags].empty?
		#	because
#		def empty?
#			true
#		end

		#	so I don't have to check to see if params[:location], or the like, exists
#	causes weird, seemingly unrelated, problems with record.save in nil.join ??
#		def map(*args,&block)
#		end

  end

end
NilClass.send( :include, NilClassExtension )

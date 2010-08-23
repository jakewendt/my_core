module RubyExtension
module IntegerExtension
	DIGITS_TO_TEXT = {
		'0' => 'zero',
		'1' => 'one',
		'2' => 'two',
		'3' => 'three',
		'4' => 'four',
		'5' => 'five',
		'6' => 'six',
		'7' => 'seven',
		'8' => 'eight',
		'9' => 'nine',
		'10' => 'ten',
		'11' => 'eleven',
		'12' => 'twelve',
		'13' => 'thirteen',
		'14' => 'fourteen',
		'15' => 'fifteen',
		'16' => 'sixteen',
		'17' => 'seventeen',
		'18' => 'eighteen',
		'19' => 'nineteen'
	}

	def self.included(base)
		base.extend(ClassMethods)
		base.instance_eval do
			include InstanceMethods
		end
	end

	module ClassMethods
	end

	module InstanceMethods

		def factorial
			f = n = self
			f *= n -= 1 while( n > 1 )
			return f
		end

		def to_english(options={})
			self.to_s.split('').collect do |digit|
				DIGITS_TO_TEXT[digit]
			end.join(' ')
		end

	end

end
end
Integer.send( :include, RubyExtension::IntegerExtension )

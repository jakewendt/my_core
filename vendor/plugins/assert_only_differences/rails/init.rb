if !defined? RAILS_ENV || RAILS_ENV == 'test' 
	require 'assert_only_differences' 
#	Test::Unit::TestCase.send( :include, AssertOnlyDifferences )
end

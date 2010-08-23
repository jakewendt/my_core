require 'acts_as_ownable'
ActiveRecord::Base.send( :include, ActsAsOwnable )

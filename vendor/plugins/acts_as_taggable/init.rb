# Include hook code here
$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'acts_as_taggable'
ActiveRecord::Base.send(:include, Jake::Acts::Taggable)

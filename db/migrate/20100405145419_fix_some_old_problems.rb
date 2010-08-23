class FixSomeOldProblems < ActiveRecord::Migration
	def self.up
		#
		#	These are changes that I see in production, but for some reason aren't in 
		#	a migration file!!!!  Only this one left, but doesn't make much difference.
		#
		change_column :photos, :stop_id, :integer, :null => true
	end

	def self.down
		change_column :photos, :stop_id, :integer, :null => false
	end
end

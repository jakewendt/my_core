class AddCommentsCountToEntries < ActiveRecord::Migration
	def self.up
		add_column :entries, :comments_count, :integer, :default => 0, :null => false
# Unnecessary
#		Entry.find(:all).each do |entry|
#			entry.comments_count = entry.comments.count
#			entry.save
#		end 
	end

	def self.down
		remove_column :entries, :comments_count
	end
end

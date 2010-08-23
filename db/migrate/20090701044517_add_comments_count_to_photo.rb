class AddCommentsCountToPhoto < ActiveRecord::Migration
	def self.up
		add_column :photos, :comments_count, :integer, :default => 0, :null => false
	end

	def self.down
		remove_column :photos, :comments_count
	end
end

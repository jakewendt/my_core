class AddCommentsCountToStop < ActiveRecord::Migration
	def self.up
		add_column :stops, :comments_count, :integer, :null => false, :default => 0
	end

	def self.down
		remove_column :stops, :comments_count
	end
end

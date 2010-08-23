class AddAssetsCountToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :assets_count, :integer, :null => false, :default => 0
	end

	def self.down
		remove_column :users, :assets_count
	end
end

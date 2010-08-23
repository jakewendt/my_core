class AddCounterCachesToTags < ActiveRecord::Migration
	def self.up
		add_column :categories, :assets_count, :integer, :null => false, :default => 0
		add_column :creators,   :assets_count, :integer, :null => false, :default => 0
		add_column :locations,  :assets_count, :integer, :null => false, :default => 0
	end

	def self.down
		remove_column :categories, :assets_count
		remove_column :creators,   :assets_count
		remove_column :locations,  :assets_count
	end
end

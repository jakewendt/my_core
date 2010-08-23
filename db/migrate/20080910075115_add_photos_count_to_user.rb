class AddPhotosCountToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :photos_count, :integer, :default => 0
	end

	def self.down
		remove_column :users, :photos_count
	end
end

class AddImagesCountToStop < ActiveRecord::Migration
	def self.up
		add_column :stops, :images_count, :integer, :null => false, :default => 0
	end

	def self.down
		remove_column :stops, :images_count
	end
end

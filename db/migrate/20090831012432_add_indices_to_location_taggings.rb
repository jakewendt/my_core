class AddIndicesToLocationTaggings < ActiveRecord::Migration
	def self.up
		add_index :location_taggings, :asset_id,    :name => 'by_asset_id'
		add_index :location_taggings, :location_id, :name => 'by_location_id'
	end

	def self.down
		remove_index :location_taggings, :name => 'by_asset_id'
		remove_index :location_taggings, :name => 'by_location_id'
	end
end

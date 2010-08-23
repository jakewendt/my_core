class AddIndicesToCreatorTaggings < ActiveRecord::Migration
	def self.up
		add_index :creator_taggings, :asset_id,   :name => 'by_asset_id'
		add_index :creator_taggings, :creator_id, :name => 'by_creator_id'
	end

	def self.down
		remove_index :creator_taggings, :name => 'by_asset_id'
		remove_index :creator_taggings, :name => 'by_creator_id'
	end
end

class AddIndicesToCategoryTaggings < ActiveRecord::Migration
	def self.up
		add_index :category_taggings, :asset_id,    :name => 'by_asset_id'
		add_index :category_taggings, :category_id, :name => 'by_category_id'
	end

	def self.down
		remove_index :category_taggings, :name => 'by_asset_id'
		remove_index :category_taggings, :name => 'by_category_id'
	end
end

class CreateCategoryTaggings < ActiveRecord::Migration
	def self.up
		create_table :category_taggings do |t|
			t.references :asset
			t.references :category
		end
	end

	def self.down
		drop_table :category_taggings
	end
end

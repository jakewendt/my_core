class CreateCreatorTaggings < ActiveRecord::Migration
	def self.up
		create_table :creator_taggings do |t|
			t.references :asset
			t.references :creator
		end
	end

	def self.down
		drop_table :creator_taggings
	end
end

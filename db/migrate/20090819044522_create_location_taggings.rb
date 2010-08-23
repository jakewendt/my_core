class CreateLocationTaggings < ActiveRecord::Migration
	def self.up
		create_table :location_taggings do |t|
			t.references :asset
			t.references :location
		end
	end

	def self.down
		drop_table :location_taggings
	end
end

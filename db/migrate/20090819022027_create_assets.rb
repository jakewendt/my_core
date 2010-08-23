class CreateAssets < ActiveRecord::Migration
	def self.up
		create_table :assets do |t|
			t.references :user
			t.string     :title
			t.text       :description
			t.string     :model
			t.string     :serial
			t.float      :cost
			t.float      :value
			t.float      :price
			t.boolean    :for_sale, :default => false
			t.date       :acquired_on
			t.date       :used_on
			t.date       :sold_on
			t.timestamps
		end
	end

	def self.down
		drop_table :assets
	end
end

class CreateLists < ActiveRecord::Migration
	def self.up
		create_table :lists do |t|
			t.integer :user_id, :null => false
			t.boolean :public, :null => false, :default => false
			t.boolean :hide, :default => false
			t.integer :items_count, :null => false, :default => 0
			t.integer :incomplete_items_count, :default => 0
			t.integer :complete_items_count, :default => 0
			t.string  :title
			t.text    :description
			t.timestamps
		end
		add_column :users, :lists_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :lists
		remove_column :users, :lists_count
	end
end

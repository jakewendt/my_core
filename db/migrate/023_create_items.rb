class CreateItems < ActiveRecord::Migration
	def self.up
		create_table :items do |t|
			t.integer :list_id, :null => false
			t.integer :position, :null => false, :default => 0
			t.boolean :completed, :default => false, :null => false
			t.datetime :completed_at
			t.string  :content
			t.timestamps
		end
	end

	def self.down
		drop_table :items
	end
end

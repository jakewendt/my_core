class CreateTopics < ActiveRecord::Migration
	def self.up
		create_table :topics do |t|
			t.integer :forum_id, :null => false
			t.integer :user_id, :null => false
			t.integer :posts_count, :null => false, :default => 0
			t.string  :name
			t.timestamps
		end
		add_column :users, :topics_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :topics
		remove_column :users, :topics_count
	end
end

class CreatePosts < ActiveRecord::Migration
	def self.up
		create_table :posts do |t|
			t.integer :topic_id, :null => true		#	why null true?
			t.integer :user_id, :null => false
			t.text    :body
			t.timestamps
		end
		add_column :users, :posts_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :posts
		remove_column :users, :posts_count
	end
end

class CreateBlogs < ActiveRecord::Migration
	def self.up
		create_table :blogs do |t|
			t.integer :user_id, :null => false
			t.boolean :hide, :default => false
			t.boolean :public, :null => false, :default => true
			t.string  :title
			t.text    :description
			t.timestamps
		end
		add_column :users, :blogs_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :blogs
		remove_column :users, :blogs_count
	end
end

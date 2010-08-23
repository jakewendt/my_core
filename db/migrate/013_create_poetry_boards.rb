class CreatePoetryBoards < ActiveRecord::Migration
	def self.up
		create_table :boards do |t|
			t.string  :title,   :null => true		#	why true?
			t.integer :user_id, :null => false
			t.timestamps
			t.boolean :public, :null => false, :default => true
			t.boolean :hide, :default => false
		end
		add_column :users, :boards_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :boards
		remove_column :users, :boards_count
	end
end

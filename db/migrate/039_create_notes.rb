class CreateNotes < ActiveRecord::Migration
	def self.up
		create_table :notes do |t|
			t.integer :user_id
			t.boolean :hide, :default => false
			t.boolean :textilize, :default => false
			t.boolean :public, :null => false, :default => false
			t.string  :title
			t.text    :body
			t.timestamps
		end
		add_column :users, :notes_count, :integer, :default => 0
	end

	def self.down
		drop_table :notes
		remove_column :users, :notes_count
	end
end

class CreatePoetryMagnets < ActiveRecord::Migration
	def self.up
		create_table :magnets do |t|
			t.string  :word,     :null => true, :default => ''
			t.integer :top,      :null => false, :default => 0
			t.integer :left,     :null => false, :default => 0
			t.integer :board_id, :null => false
			t.timestamps
		end
		add_column :boards, :magnets_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :magnets
		remove_column :boards, :magnets_count
	end
end

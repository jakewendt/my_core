class CreateEntries < ActiveRecord::Migration
	def self.up
		create_table :entries do |t|
			t.integer :blog_id, :null => true		#	why null true?
			t.string  :title
			t.text    :body
			t.timestamps
		end
		add_column :blogs, :entries_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :entries
		remove_column :blogs, :entries_count
	end
end

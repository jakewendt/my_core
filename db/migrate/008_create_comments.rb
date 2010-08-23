class CreateComments < ActiveRecord::Migration
	def self.up
		create_table :comments do |t|
			t.integer :stop_id, :null => true		#	why true?
			t.integer :user_id, :null => true		#	why true?
			t.text    :body
			t.timestamps
		end
#		add_index :comments, :stop_id
		add_index :comments, :user_id
	end

	def self.down
		drop_table :comments
	end
end

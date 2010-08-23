class CreateNewMessages < ActiveRecord::Migration
	def self.up
		create_table :messages do |t|
			t.integer :sender_id,    :null => false
			t.integer :recipient_id, :null => false
			t.boolean :read,         :null => false, :default => false
			t.string  :subject,      :null => false
			t.text    :body
			t.timestamps
		end
	end

	def self.down
		drop_table :messages
	end
end

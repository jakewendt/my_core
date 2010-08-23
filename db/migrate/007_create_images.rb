class CreateImages < ActiveRecord::Migration
	def self.up
		create_table :images do |t|
			t.integer :stop_id, :null => false
			t.integer :position, :null => false, :default => 0
			t.string  :filename
			t.text    :caption
			t.timestamps
		end
#	put me back!
#		add_index :images, :stop_id
	end

	def self.down
		drop_table :images
	end
end

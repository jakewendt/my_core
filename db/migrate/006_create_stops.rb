class CreateStops < ActiveRecord::Migration
	def self.up
		create_table :stops do |t|
			t.integer :trip_id		#,  :null => false
			t.integer :position, :null => false, :default => 0
			t.float   :lat
			t.float   :lng
			t.string  :title
			t.text    :description
			t.timestamps
		end
#		add_index :stops, :trip_id
	end

	def self.down
		drop_table :stops
	end
end

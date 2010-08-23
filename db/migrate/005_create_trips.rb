class CreateTrips < ActiveRecord::Migration
	def self.up
		create_table :trips do |t|
			t.integer :user_id, :null => true	#	why true?
			t.boolean :public, :null => false, :default => true
			t.boolean :hide, :default => false
			t.integer :stops_count, :null => false, :default => 0
			t.string  :title
			t.float   :lat,	:default =>  39, :null => true
			t.float   :lng,	:default => -95, :null => true
			t.integer :zoom, :default =>   4, :null => true
			t.text    :description
			t.timestamps
		end
		add_index :trips, :user_id
	end

	def self.down
		drop_table :trips
	end
end

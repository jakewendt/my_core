class CreateConnectFours < ActiveRecord::Migration
	def self.up
		create_table :connect_fours do |t|
			t.integer :player_1_id, :null => false
			t.integer :player_2_id, :null => false
			t.integer :turn_id
			t.integer :winner_id
			t.text :marshaled_squares
			t.timestamps
		end
	end

	def self.down
		drop_table :connect_fours
	end
end

class CreateTicTacToes < ActiveRecord::Migration
	def self.up
		create_table :tic_tac_toes do |t|
			t.integer :player_1_id, :null => false
			t.integer :player_2_id, :null => false
			t.integer :turn_id
			t.integer :winner_id
			t.integer :square_0_id
			t.integer :square_1_id
			t.integer :square_2_id
			t.integer :square_3_id
			t.integer :square_4_id
			t.integer :square_5_id
			t.integer :square_6_id
			t.integer :square_7_id
			t.integer :square_8_id
			t.timestamps
		end
	end

	def self.down
		drop_table :tic_tac_toes
	end
end

require File.dirname(__FILE__) + '/../test_helper'

class TicTacToeTest < ActiveSupport::TestCase

	add_two_player_game_unit_tests :tic_tac_toe

	test "should allow batter to select square" do
		tic_tac_toe = create_tic_tac_toe
		tic_tac_toe.choose_square(tic_tac_toe.batter, 0)
		assert_nil tic_tac_toe.winner_id
		#	compare to on_deck as the batter is now on_deck
		assert_equal tic_tac_toe.on_deck, tic_tac_toe.square_0_id
	end

	test "should NOT allow player on deck to select square" do
		tic_tac_toe = create_tic_tac_toe
		assert_raises(TicTacToe::NotPlayersTurn){ tic_tac_toe.choose_square(tic_tac_toe.on_deck, 0) }
	end

	test "should NOT allow batter to select taken square" do
		tic_tac_toe = create_tic_tac_toe
		tic_tac_toe.choose_square(tic_tac_toe.batter, 0)
		assert_raises(TicTacToe::SquareTaken){ tic_tac_toe.choose_square(tic_tac_toe.batter, 0) }
	end

	test "should NOT allow batter to select invalid square" do
		tic_tac_toe = create_tic_tac_toe
		assert_raises(TicTacToe::InvalidSquare){ tic_tac_toe.choose_square(tic_tac_toe.batter, 9) }
	end

	test "should NOT allow player to select square when game is over" do
		tic_tac_toe = create_tic_tac_toe
		tic_tac_toe.update_attribute(:turn_id, nil)
		assert_raises(TicTacToe::GameOver){ tic_tac_toe.choose_square(tic_tac_toe.player_1_id, 0) }
	end

	test "should play game until winner" do
		tic_tac_toe = create_tic_tac_toe
		batter = tic_tac_toe.batter
		tic_tac_toe.choose_square(tic_tac_toe.reload.batter, 0)
		tic_tac_toe.choose_square(tic_tac_toe.reload.batter, 3)
		tic_tac_toe.choose_square(tic_tac_toe.reload.batter, 1)
		tic_tac_toe.choose_square(tic_tac_toe.reload.batter, 4)
		tic_tac_toe.choose_square(tic_tac_toe.reload.batter, 2)
		assert_equal tic_tac_toe.reload.winner_id, batter
		assert tic_tac_toe.won?
		assert tic_tac_toe.won_by?(User.find(batter))
	end

protected

	def create_tic_tac_toe(options = {})
		record = Factory.build(:tic_tac_toe,options)
		record.save
		record
	end
	alias create_game create_tic_tac_toe

end

require File.dirname(__FILE__) + '/../test_helper'

class ConnectFourTest < ActiveSupport::TestCase

	add_two_player_game_unit_tests :connect_four

	test "should marshal squares after save" do
		connect_four = Factory.build(:connect_four)
		assert_nil connect_four.marshaled_squares
		connect_four.save
		assert_not_nil connect_four.marshaled_squares
		assert_equal [], connect_four.squares.collect{|column| column.collect{|row| row[:player] } }.flatten.compact
	end

	test "should NOT allow player on deck to select column" do
		connect_four = create_connect_four
		assert_raises(ConnectFour::NotPlayersTurn){ connect_four.choose_column(connect_four.on_deck, 0) }
	end

	test "should NOT allow batter to select taken column" do
		connect_four = create_connect_four
		connect_four.squares[0]=[1,2,3,4,5,6]
		assert_raises(ConnectFour::ColumnFull){ connect_four.choose_column(connect_four.batter, 0) }
	end

	test "should NOT allow batter to select invalid column" do
		connect_four = create_connect_four
		assert_raises(ConnectFour::InvalidColumn){ connect_four.choose_column(connect_four.batter, 9) }
	end

	test "should NOT allow player to select column when game is over" do
		connect_four = create_connect_four
		connect_four.update_attribute(:turn_id, nil)
		assert_raises(ConnectFour::GameOver){ connect_four.choose_column(connect_four.player_1_id, 0) }
	end

	test "should play til vertical winner" do
		connect_four = create_connect_four
		batter = connect_four.batter
		%w( 0 1 0 1 0 1 0 ).each do |column|
			connect_four.choose_column(connect_four.reload.batter, column)
		end
		assert_equal connect_four.reload.winner_id, batter
		assert connect_four.won?
		assert connect_four.won_by?(User.find(batter))
		assert connect_four.squares[0][0][:winner]
		assert connect_four.squares[0][1][:winner]
		assert connect_four.squares[0][2][:winner]
		assert connect_four.squares[0][3][:winner]
	end

	test "should play til horizontal winner" do
		connect_four = create_connect_four
		batter = connect_four.batter
		%w( 0 0 1 1 2 2 3 ).each do |column|
			connect_four.choose_column(connect_four.reload.batter, column)
		end
		assert_equal connect_four.reload.winner_id, batter
		assert connect_four.won?
		assert connect_four.won_by?(User.find(batter))
		assert connect_four.squares[0][0][:winner]
		assert connect_four.squares[1][0][:winner]
		assert connect_four.squares[2][0][:winner]
		assert connect_four.squares[3][0][:winner]
	end

	test "should play til up diagonal winner" do
		connect_four = create_connect_four
		batter = connect_four.batter
		%w( 0 1 1 2 2 3 2 3 3 5 3 ).each do |column|
			connect_four.choose_column(connect_four.reload.batter, column)
		end
		assert_equal connect_four.reload.winner_id, batter
		assert connect_four.won?
		assert connect_four.won_by?(User.find(batter))
		assert connect_four.squares[0][0][:winner]
		assert connect_four.squares[1][1][:winner]
		assert connect_four.squares[2][2][:winner]
		assert connect_four.squares[3][3][:winner]
	end

	test "should play til down diagonal winner" do
		connect_four = create_connect_four
		batter = connect_four.batter
		%w( 6 5 5 4 4 3 4 3 3 1 3 ).each do |column|
			connect_four.choose_column(connect_four.reload.batter, column)
		end
		assert_equal connect_four.reload.winner_id, batter
		assert connect_four.won?
		assert connect_four.won_by?(User.find(batter))
		assert connect_four.squares[6][0][:winner]
		assert connect_four.squares[5][1][:winner]
		assert connect_four.squares[4][2][:winner]
		assert connect_four.squares[3][3][:winner]
	end

protected

	def create_game(options = {})
		record = Factory.build(:connect_four,options)
		record.save
		record
	end
	alias create_connect_four create_game

end

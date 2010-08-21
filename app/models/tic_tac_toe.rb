class TicTacToe < ActiveRecord::Base

	acts_as_two_player_game

	class SquareTaken < StandardError; end
	class InvalidSquare < StandardError; end

	def choose_square(player_id, square_number)
		square_number = square_number.to_i
		raise GameOver       if  game_over?
		raise NotPlayersTurn if !users_turn?(player_id)
		raise InvalidSquare  if !valid_square?(square_number)
		raise SquareTaken    if !open_square?(square_number)
		self.send("square_#{square_number}_id=", player_id)
		self.check_for_winner
		self.turn_id = on_deck if self.still_playing?
		self.save
	end

	def squares
		(0..8).collect{|i| self.send("square_#{i}_id") }
	end

	def open_square?(i)
		self.send("square_#{i}_id").nil? and self.still_playing?
	end

protected

	def valid_square?(square_number)
		(0..8).include?(square_number)
	end

	def winners
		@winners ||= [
			[0,1,2],
			[3,4,5],
			[6,7,8],
			[0,3,6],
			[1,4,7],
			[2,5,8],
			[0,4,8],
			[2,4,6]
		]
	end

	def check_for_winner
		return if !winner_id.nil?
		winners.each do |winner|
			if squares.values_at(*winner).eql?([batter]*3)
				self.attributes = {
					:turn_id   => nil,
					:winner_id => batter
				}
				break
			end
		end
		self.turn_id = nil if winner_id.nil? and squares.all?
	end

end

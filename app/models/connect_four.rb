class ConnectFour < ActiveRecord::Base

	acts_as_two_player_game

	class ColumnFull < StandardError; end
	class InvalidColumn < StandardError; end

	before_save :marshal_squares

	def squares
		@squares ||= if self.marshaled_squares.blank?
			(0..6).collect{|i| Array.new(6){Hash.new} }
		else
			Marshal.load(marshaled_squares)
		end
	end

	def choose_column(player_id, column_number)
		column_number = column_number.to_i
		raise GameOver       if  game_over?
		raise NotPlayersTurn if !users_turn?(player_id)
		raise InvalidColumn  if !valid_column?(column_number)
		raise ColumnFull     if  column_full?(column_number)

		squares[column_number][first_empty_row_in_column(column_number)][:player] = player_id

		self.check_for_winner
		self.turn_id = on_deck if self.still_playing?
		self.save
	end

protected

	def valid_column?(column_number)
		(0..squares.length).include?(column_number)
	end

	def column_full?(column_number)
		squares[column_number].collect{|s|s[:player]}.all?
	end

	def first_empty_row_in_column(column_number)
		squares[column_number].first_index{|s|s[:player].nil?}
	end

	def board_full?
		squares.collect{|a| a.collect{|s|s[:player]}.all? }.all?
	end

	def down_diagonals
		i = -1
		arr = squares.collect do |column|
			i += 1
			Array.new(6-i){Hash.new} + column + Array.new(i){Hash.new}
		end
		arr.transpose
	end

	def up_diagonals
		i = -1
		arr = squares.collect do |column|
			i += 1
			Array.new(i){Hash.new} + column + Array.new(6-i){Hash.new}
		end
		arr.transpose
	end

	def check_for_winner
		return if !winner_id.nil?
		#	squares for vertical check
		#	squares.transpose for horizontal check
		#	up_diagonals for up diagonal check
		#	down_diagonals for down diagonal check
		(squares+squares.transpose+down_diagonals+up_diagonals).each do |a| 
			a.each_cons(4).each do |cons| 
				w = cons.collect{|s|s[:player]}.uniq
				if w.length == 1 && w.all?
					self.attributes = {
						:turn_id   => nil,
						:winner_id => w.first		#	batter
					}
					cons.each{|c|c[:winner] = true}
					break
				end
				break if !winner_id.nil?
			end
		end
		self.turn_id = nil if winner_id.nil? and board_full?
	end

	def marshal_squares
		self.marshaled_squares = Marshal.dump(squares)
	end

end

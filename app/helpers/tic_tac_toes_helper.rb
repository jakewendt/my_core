module TicTacToesHelper
	
	def ttt_players(game)
		s = "<p id='players'>"
		classes = ['player']
		classes.push('turn')   if game.player_1_id == game.turn_id
		classes.push('winner') if game.won_by?(:player_1)
		s << "<span class='#{classes.join(' ')}'>(X) #{h game.player_1.login }</span>"
		s << "<span> versus </span>"
		classes = ['player']
		classes.push('turn')   if game.player_2_id == game.turn_id
		classes.push('winner') if game.won_by?(:player_2)
  	s << "<span class='#{classes.join(' ')}'>#{h game.player_2.login } (O)</span>"
		s << "</p>"
	end

	def ttt_square(i)
		classes = ['square']
#		classes.push('open')    if @tic_tac_toe.open_square_for?(current_user.id,i)
		classes.push('open')    if @tic_tac_toe.open_square?(i)
		classes.push('player_1')if @tic_tac_toe.send("square_#{i}_id") == @tic_tac_toe.player_1_id
		classes.push('player_2')if @tic_tac_toe.send("square_#{i}_id") == @tic_tac_toe.player_2_id
		"<div id='square_#{i}' class='#{classes.join(' ')}'>&nbsp;</div>"
	end

end

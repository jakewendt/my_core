module ConnectFoursHelper
	
	def c4_players(game)
		s = "<p id='players'>"
		classes = ['player', 'player_1']
		classes.push('turn')   if game.player_1_id == game.turn_id
		classes.push('winner') if game.won_by?(:player_1)
		s << "<span class='#{classes.join(' ')}'>#{h game.player_1.login }</span>"
		s << "<span> versus </span>"
		classes = ['player', 'player_2']
		classes.push('turn')   if game.player_2_id == game.turn_id
		classes.push('winner') if game.won_by?(:player_2)
  	s << "<span class='#{classes.join(' ')}'>#{h game.player_2.login }</span>"
		s << "</p>"
	end

end

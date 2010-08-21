module BoardsHelper

	def classes_for_board(board)
		classes = ['row']
		classes.push('otheruser') if board.user_id != current_user.id
		classes.push('public') if board.public
		classes.join(' ')
	end

end

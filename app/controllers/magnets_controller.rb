class MagnetsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => :update
	before_filter :get_board
	before_filter :require_owner, :except => [ :update ]

	def create
		params[:magnet] ||= HashWithIndifferentAccess.new
		params[:magnet][:word] = 'New Magnet' if params[:magnet][:word].blank?
		@magnet = @board.magnets.new(params[:magnet])
		saved = @magnet.save
		respond_to do |format|
			format.html do
				if saved
					flash[:notice] = 'Magnet created'
				else
					flash[:error] = 'Magnet creation FAILED!'
				end
				redirect_to edit_board_path(@magnet.board)
			end
			format.js do
				render :text => '' unless saved
			end
		end
	end

	def update
		@magnet.move_to_bottom
		@magnet.top	= params[:magnet][:top]
		@magnet.left = params[:magnet][:left]
		@magnet.save!
#	TODO
#	add a respond_to block
#	If the user doesn't have javascript enabled, boards won't work anyway
#	might want to put some text on the screen if user has javascript disabled
#	would like to add a highlight or something like a glow when magnet dropped
	rescue
		flash.now[:error] = 'Magnet update FAILED!'
		render :text => ''
	end

private

	def get_board
		if( params[:board_id] )
			@board	 = Board.find(params[:board_id], :include => :magnets)
			@magnets = @board.magnets
			@magnet	= @magnets.find(params[:id]) if params[:id]
		else
			@magnet = Magnet.find(params[:id])
			@board = @magnet.board
		end
	end

end

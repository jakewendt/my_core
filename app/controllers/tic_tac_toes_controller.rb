class TicTacToesController < ApplicationController
	before_filter :login_required
	before_filter :player_required, :only => [:show, :update]

	def index
		@page_title = "Tic Tac Toe Games"
		@tic_tac_toes = current_user.tic_tac_toes
	end

	def show
		@page_title = "Tic Tac Toe"
		respond_to do |format|
			format.html {}
			format.js do
				unless JUGGERNAUT_ENABLED
					if( @tic_tac_toe.users_turn?(current_user) or @tic_tac_toe.game_over? )
						render(:update){ |page| page.replace_html dom_id(@tic_tac_toe), :partial => 'game_board' }
					else
						render(:update){ |page| page << "setTimeout(function(){reload_board();},5000);" }
					end
				end
			end
		end
	end

	def new
		@page_title = "Challenge someone to Tic Tac Toe"
		@tic_tac_toe = current_user.tic_tac_toes.new
	end

	def create
		@tic_tac_toe = current_user.tic_tac_toes.new(params[:tic_tac_toe])

		if @tic_tac_toe.save
			redirect_to(@tic_tac_toe)
		else
			flash[:error] = "There was a problem creating a new game."
			render :action => "new"
		end
	end

	def update
		@tic_tac_toe.choose_square(current_user.id, params[:square])
		render :juggernaut => {:type => :send_to_channel, :channel => dom_id(@tic_tac_toe)} do |page|
			page.replace_html dom_id(@tic_tac_toe), :partial => 'game_board'
		end
		render :text => ""	#	without this, tests fail when juggernaut server is running
	rescue Errno::ECONNREFUSED	#	this happens when juggernaut not running
		flash.now[:error] = "Juggernaut server connection failed."
#		render :text => ""		#	perhaps I should redirect
#		render(:update){ |page| page << "alert('Juggernaut connection failed.')" }
		render(:update){ |page| page.replace_html dom_id(@tic_tac_toe), :partial => 'game_board' }
	rescue TicTacToe::NotPlayersTurn
		flash.now[:error] = "Sorry, but its not your turn."
#		render :text => ""		#	perhaps I should redirect
		render(:update){ |page| page << "alert('Sorry, but its not your turn.')" }
	end

protected

	def player_required
		@tic_tac_toe = TicTacToe.find(params[:id])
		unless( @tic_tac_toe.players.include?(current_user.id) || current_user.is_admin? )
			permission_denied("Sorry, but you're not a player in this game.")
		end
	end

end

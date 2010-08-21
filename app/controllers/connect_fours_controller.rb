class ConnectFoursController < ApplicationController
	before_filter :login_required
	before_filter :player_required, :only => [:show, :update]

	def index
		@page_title = "Connect Four Games"
		@connect_fours = current_user.connect_fours
	end

	def show
		@page_title = "Connect Four"
		respond_to do |format|
			format.html {}
			format.js do
				unless JUGGERNAUT_ENABLED
					if( @connect_four.users_turn?(current_user) or @connect_four.game_over? )
						render(:update){ |page| page.replace_html dom_id(@connect_four), :partial => 'game_board' }
					else
						render(:update){ |page| page << "setTimeout(function(){reload_board();},5000);" }
					end
				end
			end
		end
	end

	def new
		@page_title = "Challenge someone to Connect Four"
		@connect_four = current_user.connect_fours.new
	end

	def create
		@connect_four = current_user.connect_fours.new(params[:connect_four])

		if @connect_four.save
			redirect_to(@connect_four)
		else
			flash[:error] = "There was a problem creating a new game."
			render :action => "new"
		end
	end

	def update
		@connect_four.choose_column(current_user.id, params[:column])
		render :juggernaut => {:type => :send_to_channel, :channel => dom_id(@connect_four)} do |page|

			#	I'd really rather only return a much smaller piece of javascript
			#	but for now ...

			page.replace_html dom_id(@connect_four), :partial => 'game_board'
		end
		render :text => ""	#	without this, tests fail when juggernaut server is running
	rescue Errno::ECONNREFUSED	#	this happens when juggernaut not running
		flash.now[:error] = "Juggernaut server connection failed."
#		render :text => ""		#	perhaps I should redirect
#		render(:update){|page| page << "alert('Juggernaut connection failed.')" }
#		render :update do |page| page << "alert('Juggernaut connection failed.')" end
		render(:update){ |page| page.replace_html dom_id(@connect_four), :partial => 'game_board' }
	rescue ConnectFour::NotPlayersTurn
		flash.now[:error] = "Sorry, but its not your turn."
#		render :text => ""		#	perhaps I should redirect
		render(:update){|page| page << "alert('Sorry, but its not your turn.')" }
#		render :update do |page| page << "alert('Sorry, but its not your turn.')" end
	end

protected

	def player_required
		@connect_four = ConnectFour.find(params[:id])
		unless( @connect_four.players.include?(current_user.id) || current_user.is_admin? )
			permission_denied("Sorry, but you're not a player in this game.")
		end
	end

end

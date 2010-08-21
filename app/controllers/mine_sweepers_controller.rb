class MineSweepersController < ApplicationController

	def show
		@page_title = "Mine Sweeper"
	end

	def new
		@page_title = "New Mine Sweeper Game"
	end

end

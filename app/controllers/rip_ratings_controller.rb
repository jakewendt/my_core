class RipRatingsController < ApplicationController
	skip_before_filter :verify_authenticity_token

	def show
	end

	def create
		ripper = Ripper.new(params[:netflix_cookie])
		ripper.rip
		@netflix_url = ripper.url
		@titles = ripper.titles
	end

	def update
		ripper = Ripper.new(params[:netflix_cookie], params[:netflix_url])
		ripper.rip
		@netflix_url = ripper.url
		@titles = ripper.titles
	end

end

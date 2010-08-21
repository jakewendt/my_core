class ForumsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :check_administrator_role, :except => [:index, :show]
	before_filter :get_forum, :only => [:edit, :update, :destroy]

	def index
		@forums = Forum.find(:all)
	end

	def show
		redirect_to forum_topics_path(params[:id])
	end

	def new
		@forum = Forum.new
	end

	def create
		@forum = Forum.new(params[:forum])
		if @forum.save
			flash[:notice] = 'Forum was successfully created.'
			redirect_to forums_path
		else
			flash.now[:error] = 'Forum creation failed.'
			render :action => "new"
		end
	end

	def edit
	end

	def update
		if @forum.update_attributes(params[:forum])
			flash[:notice] = 'Forum was successfully updated.'
			redirect_to(@forum)
		else
			flash.now[:error] = 'Forum update failed.'
			render :action => "edit"
		end
	end

	def destroy
		@forum.destroy
		redirect_to(forums_url)
	end

protected

	def get_forum
		@forum = Forum.find(params[:id], :include => :topics)
	end

end

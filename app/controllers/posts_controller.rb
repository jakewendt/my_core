class PostsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [:index, :show]
	before_filter :get_forum_and_topic
	before_filter :require_owner, :only => [ :edit, :update, :destroy ]

	def new
		@post = Post.new
	end

	def create 
		@post = Post.new(:body => params[:post][:body])
		@post.topic = @topic
		@post.user = current_user
		@post.save!
		flash[:notice] = 'Post was successfully created.' 
		redirect_to topic_posts_path( @topic)
	rescue
		flash.now[:error] = 'Post creation failed.'
		render :action => "new"
	end 

	def update 
		@post.update_attributes!(params[:post]) 
		flash[:notice] = 'Post was successfully updated.' 
		redirect_to topic_posts_path( @topic )
	rescue
		flash.now[:error] = 'Post update failed.'
		render :action => "edit"
	end 

	def destroy 
		@post.destroy 
		redirect_to topic_posts_path( @topic )
	end 

	def index
	end

	def show
		redirect_to topic_posts_path( @topic )
	end

	def edit
	end

protected

	def get_forum_and_topic
#		if( params[:forum_id] )
#			@forum = Forum.find(params[:forum_id], :include => :topics)
#			@topic = @forum.topics.find(params[:topic_id])
#			@posts = @topic.posts
#			@post	 = @topic.posts.find(params[:id]) if params[:id]
#		elsif( params[:topic_id] )
		if( params[:topic_id] )
			@topic = Topic.find(params[:topic_id])
			@forum = @topic.forum
			@posts = @topic.posts
			@post	 = @posts.find(params[:id]) if params[:id]
		else
			@post  = Post.find(params[:id])
			@topic = @post.topic
			@forum = @topic.forum
		end
	end

end

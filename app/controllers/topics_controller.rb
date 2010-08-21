class TopicsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [:index, :show] 
	before_filter :get_forum_and_topics
	# requires current_user and @topic
	before_filter :require_owner, :only => [ :edit, :update, :destroy ]

	def index
	end

	def show 
		redirect_to topic_posts_path( @topic )
	end 

	def new 
		@topic = Topic.new 
		@post = Post.new 
	end 

	def create 
#		@topic = Topic.new(:name => params[:topic][:name])
#		@topic.forum = @forum
#		@topic.user	= current_user
#		@topic.save! 
#		@post = Post.new(:body => params[:post][:body])
#		@post.topic = @topic
#		@post.user = current_user
#		@post.save! 
		# modified so that topic doesn't get created when
		# first post fails validation which caused multiple
		# instances of the same topic name to be created
		@topic = @forum.topics.new(:name => params[:topic][:name])
		@topic.user	= current_user
		@post = Post.new(:body => params[:post][:body])
		@post.user = current_user
		if ( @topic.valid? and @post.valid? )
			@topic.save
			@post.topic = @topic
			@post.save
			redirect_to topic_posts_path( @topic )
		else
			flash.now[:error] = 'Topic creation failed.'
			render :action => 'new'
		end
	end 

	def edit
	end

	def update 
		@topic.update_attributes!(params[:topic]) 
		flash[:notice] = 'Topic was successfully updated.' 
		redirect_to topic_posts_path( @topic )
	rescue
		flash.now[:error] = 'Topic update failed.'
		render :action => "edit"
	end 

	def destroy 
		@topic.destroy 
		redirect_to forum_topics_path( @forum )
	end 

protected

	def get_forum_and_topics
		if( params[:forum_id] )
			@forum  = Forum.find( params[:forum_id], :include => :topics )
			@topics = @forum.topics
			@topic  = @forum.topics.find(params[:id]) if params[:id]
		else
			@topic = Topic.find(params[:id])
			@forum = @topic.forum
		end
	end

end

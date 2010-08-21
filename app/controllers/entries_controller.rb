class EntriesController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :index, :show ]
	before_filter :get_blog
	# requires current_user and @blog
	before_filter :require_owner, :except => [ :index, :show, :create_comment ]

	add_create_comment :entry
	add_photoability	 :entry

#	def index
#		redirect_to( @blog )
#	end

	def show
		@page_title = @entry.title
	end

	def new
		@page_title = "New Entry"
		@entry = Entry.new
	end

	def create
		@entry = Entry.new( params[:entry] )
		@entry.blog = @blog
		@entry.save!
		flash[:notice] = 'Entry was successfully created.'
		redirect_to( @blog )
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating this entry."
		render :action => "new"
	end

	def edit
		@page_title = "Edit Entry"
		@photoable = @entry
	end

	def update
#		update_result = @entry.update_attributes( params[:entry] )
#		@entry.photos.collect do |photo|
#			# I don't understand why I need this "if"
#			# If there aren't any magnets, it shouldn't be here?
#			if params[:photo]
#				update_result &&= photo.update_attributes( params[:photo][photo.id.to_s] )
#			end 
#		end 
#		if update_result
#			redirect_to( @entry )
##			redirect_to( @blog )
#		else
#			render :action => 'edit'
#		end

#	TODO
#	cleanup and remove !s and use the update_result &&= technique
		@entry.update_attributes!( params[:entry] )
		@entry.photos.each do |photo|
			if params[:photo]
				photo.update_attributes!( params[:photo][photo.id.to_s] )
			end 
		end 
		redirect_to( @entry )
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating this entry."
		render :action => 'edit'
	end 

	def destroy
		@entry.destroy
		redirect_to( @blog )
	end

protected

	def get_blog
		if ( params[:blog_id] )
			@blog		= Blog.find( params[:blog_id], :include => :entries )
			@entries = @blog.entries
			@entry	 = @entries.find( params[:id] ) if params[:id]
		else
			# handle /entries/:id from redirect_to(@comment.commentable)
			@entry	 = Entry.find( params[:id], :include => :photos )
			@blog		= @entry.blog
		end
	end

end

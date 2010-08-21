class PhotosController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :show, :index ]
	before_filter :get_photo, :except => [ :index, :new, :create ]
	# requires current_user and @photo
	before_filter :require_owner, :only => [ :edit, :update, :confirm_destroy, :destroy ]

	add_create_comment :photo

	def confirm_destroy
	end

	def index
		@page_title = "Photos"
		if params[:user_id]
			@user = User.find(params[:user_id], :include => :photos)
		elsif logged_in?
			@user = current_user
		else
			redirect_to( login_path )
			return false	# force an exit
		end
		@photos = @user.photos
	rescue ActiveRecord::RecordNotFound
		flash[:error] = "Record Not Found with ID #{params[:user_id]}"
		redirect_to( root_path )
	end

	def show
		@page_title = "Photo"
	end

	def new
		@page_title = "Create New Photo"
		@photo = current_user.photos.new
#	TODO
#	add a respond_to block
	end

	def create
		@photo = current_user.photos.build(params[:photo])
		@photo.save!
		flash[:notice] = 'Photo was successfully created.'
		redirect_to(@photo)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = 'There was a problem creating the photo.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit Photo"
	end

	def update
		@photo.update_attributes!(params[:photo])
		flash[:notice] = 'Photo was successfully updated.'
		redirect_to(@photo) 
#	TODO
#	add a respond_to block (do I ever do an rjs update?)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = 'There was a problem updating the photo.'
		render :action => "edit"
	end

	def destroy
		@photo.destroy
		respond_to do |format|
			format.html { redirect_to(photos_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@photo)
					page << "if ( jQuery('#photos_count') ) {"
					page.replace_html "photos_count", @photo.user.photos.count
					page << "}"
				end
			end
		end
	end

protected

	def get_photo
		@photo = Photo.find(params[:id])
	end

end

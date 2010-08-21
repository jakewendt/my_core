class PagesController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :check_administrator_role, :except => [ :show, :show_position ]

	def index
		@page_title = "Pages"
		@pages = Page.find_all
	end

	def show
		if params[:path]
 			@page = Page.by_path("/#{params[:path].join('/')}")
			if @page.nil?
	 			@page = Page.by_title("/#{params[:path].join('/')}")
				raise ActiveRecord::RecordNotFound if @page.nil?
			end
		else
			@page = Page.find(params[:id])
		end
		@page_title = @page.title
	rescue ActiveRecord::RecordNotFound
		flash[:error] = "Page not found with ID #{params[:id]} or path #{params[:path]}"
	end

	def new
		@page_title = "Create New Page"
		@page = Page.new
	end

	def edit
		@page_title = "Edit Page"
		@page = Page.find(params[:id])
	end

	def create
		@page = Page.new(params[:page])
		@page.save!
		flash[:notice] = 'Page was successfully created.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem creating the page"
		render :action => "new"
	end

	def update
		@page = Page.find(params[:id])
		@page.update_attributes!(params[:page])
		flash[:notice] = 'Page was successfully updated.'
		redirect_to(@page)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "There was a problem updating the page."
		render :action => "edit"
	end

	def destroy
		@page = Page.find(params[:id])
		@page.destroy
		redirect_to(pages_path)
	end

	def move_lower
		@page = Page.find(params[:id])
		@page.move_lower
		redirect_to pages_path
	end

	def move_higher
		@page = Page.find(params[:id])
		@page.move_higher
		redirect_to pages_path
	end

	def show_position
		@page = Page.find_by_position(params[:id])
		@page_title = @page.title
		# the find_by_* methods do not raise exceptions when nothing is found so don't need rescuing
		render :action => 'show'
	end

end

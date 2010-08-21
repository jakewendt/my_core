class CategoriesController < ApplicationController
	before_filter :login_required
	before_filter :get_category, :except => :index
	before_filter :require_owner, :except => :index

	def index
		@categories = current_user.categories
	end

	def show
		redirect_to(assets_path(:category => @category.name))
	end

	def edit
	end

	def update
		@category.update_attributes!(params[:category])
		flash[:notice] = 'Category was successfully updated.'
		redirect_to(@category)
	rescue
		flash.now[:error] = 'Category update failed.'
		render :action => "edit"
	end

	def destroy
		@category.destroy
		redirect_to(categories_url)
	end

protected

	def get_category
		@category = Category.find(params[:id])
	end

end

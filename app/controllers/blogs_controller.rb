class BlogsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :show ]
	before_filter :get_blog, :except => [ :index, :new, :create ]
	# requires current_user and @blog
	before_filter :require_owner, :only => [ :edit, :update, :confirm_destroy, :destroy ]
	before_filter :check_blog_public, :only => [ :show ]
	before_filter :check_pdf_download, :only => [ :index ]

	def confirm_destroy
	end

	def index
		@page_title = "Blogs"
		@blogs = Blog.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=blogs_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		# respond_to not really needed, but is it due to the layout?
		@page_title = @blog.title
		respond_to do |format|
			format.html #{ render :layout => "showtrip" } # show.html.erb
			format.txt {
				headers["Content-disposition"] = "attachment; filename=blog_#{@blog.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.rss	{ render :layout => false, :rss => @blog }
			format.pdf { prawnto :filename => "blog_#{@blog.id}_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

	def new
		@blog = Blog.new
	end

	def create
		@blog = current_user.blogs.new( params[:blog] )
		@blog.save!
		flash[:notice] = 'Blog was successfully created.'
		redirect_to( @blog )
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = 'Blog creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit " + @blog.title
	end

	def update
		@blog.update_attributes!( params[:blog] )
		flash[:notice] = 'Blog was successfully updated.'
		redirect_to( @blog )
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = 'Blog update failed.'
		render :action => "edit"
	end

	def destroy
		@blog.destroy
		respond_to do |format|
			format.html { redirect_to( blogs_url ) }
			format.js do
				render :update do |page|
					page.remove dom_id(@blog)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#blogs_count') ) {"
					page.replace_html "blogs_count", @blog.user.blogs.count
					page << "}"
				end
			end
		end
	end

protected

	def get_blog
		@blog = Blog.find( params[:id], :include => :entries )
		@entries = @blog.entries
	end

	def check_blog_public
		check_public( @blog )
	end

end

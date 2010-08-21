class ResumesController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	# resumes are 80% private
	before_filter :login_required, :except => [ :show ]
	before_filter :get_resume, :except => [ :index, :new, :create ]
	# requires current_user and @resume
	before_filter :require_owner, :only => [ :edit, :update, :confirm_destroy, :destroy ]
	before_filter :check_resume_public, :only => [ :show ]
	before_filter :check_pdf_download, :only => [ :index ]

	def confirm_destroy
	end

	def index
		@page_title = "Resumes"
		@resumes = Resume.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=resumes_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		@page_title = @resume.title
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=resume_#{@resume.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.pdf { prawnto :filename => "resume_#{@resume.id}_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

	def new
		@page_title = "Create New Resume"
		@resume = Resume.new
	end

	def create
		@resume = current_user.resumes.new(params[:resume])
		@resume.save!
		flash[:notice] = 'Resume was successfully created.'
		redirect_to edit_resume_url(@resume)
	rescue
		flash.now[:error] = 'Resume creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit Resume"
	end

	def update
		if @resume.update_attributes(params[:resume])
			redirect_to @resume
		else
			flash.now[:error] = 'Resume update failed.'
			render :action => 'edit'
		end
	end 

	def destroy
		@resume.destroy
		respond_to do |format|
			format.html { redirect_to(resumes_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@resume)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#resumes_count') ) {"
					page.replace_html "resumes_count", @resume.user.resumes.count
					page << "}"
				end
			end
		end
	end

protected

	def get_resume
		@resume = Resume.find(params[:id],
			:include => [ :jobs, :schools, :affiliations, :publications,
				{ :skills		=> :level }, 
				{ :languages => :level }
			]
		)
	end

	def check_resume_public
		check_public(@resume)
	end

end

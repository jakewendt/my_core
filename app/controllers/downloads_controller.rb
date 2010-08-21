class DownloadsController < ApplicationController
	before_filter :login_required
	before_filter :get_download,  :except => [ :index, :create ]
	before_filter :require_owner, :except => [ :index, :create ]
	
	def index
		@page_title = "My Downloads"
		@downloads = current_user.downloads.search(params)
	end

	def show
		@page_title = "Download " + @download.name
	end

	def download
		if @download.completed_at
			send_file @download.server_file, :filename => @download.local_file
#				:x_sendfile => true #	don't have installed on localhost
#				Maybe on jakewendt.com????
#				:type     => "application/pdf",	#	doesn't seem to be needed?
		else
			render :action => "show"
		end
	end

	def create
		@download = current_user.downloads.new(params[:download])
		@download.save!
		flash[:notice] = 'Download was successfully created.'
		redirect_to(@download)
	rescue
		flash[:error] = 'Download creation failed.'
		redirect_back_or_default(mystuff_path)
	end

	def destroy
		@download.destroy
		respond_to do |format|
			format.html { redirect_to(downloads_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@download)
				end
			end
		end
	end

	def edit
	end

	def update
		@download.update_attributes!(params[:download])
		flash[:notice] = 'Download was successfully updated.'
		redirect_to downloads_path
	rescue
		flash.now[:error] = 'Download update failed.'
		render :action => "edit"
	end

protected

	def get_download
		@download = Download.find(params[:id])
	end

end

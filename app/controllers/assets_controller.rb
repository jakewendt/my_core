class AssetsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required
	before_filter :get_asset,     :except => [ :index, :new, :create, :batch_new, :batch_create, :stream_edit ]
#	before_filter :require_owner, :except => [ :index, :new, :create, :batch_new, :batch_create, :stream_edit ]
	before_filter :require_asset_owner, :except => [ :index, :new, :create, :batch_new, :batch_create, :stream_edit, :show ]
	before_filter :require_asset_for_sale, :only => :show
	before_filter :check_pdf_download, :only => :index

	def confirm_destroy
	end

	def index
		@page_title = "My Assets"
		if params[:format].blank?
			@assets = current_user.assets.search(params).paginate({
				:page => params[:page], 
				:per_page => params[:per_page]||PER_PAGE
			})
		else
			@assets = current_user.assets.search(params)
		end
		respond_to do |format|
			format.html {	render :action => 'index' }
			format.txt { 
				headers["Content-disposition"] = "attachment; filename=assets_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		@page_title = @asset.title
		respond_to do |format|
			format.html
			format.txt { 
				headers["Content-disposition"] = "attachment; filename=asset_#{@asset.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.pdf { prawnto :filename => "asset_#{@asset.id}_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

	def new
		@asset = Asset.new
	end

	def create
		@asset = current_user.assets.new(params[:asset])
		@asset.save!
		flash[:notice] = 'Asset was successfully created.'
		redirect_to(@asset)
	rescue
		flash.now[:error] = "Asset creation failed."	#\n#{@asset.errors.inspect}"
		render :action => "new"
	end



	def batch_new
		@asset = Asset.new
	end

	def batch_create
		new_assets_count = 0
		params[:titles].split("\n").each do |title|
			title = title.chomp
			next if title.blank?
			@asset = current_user.assets.new(params[:asset])
			@asset.title = title
			@asset.save!
			new_assets_count += 1
		end
		if new_assets_count > 0
			flash[:notice] = "#{@template.pluralize(new_assets_count,'asset was', 'assets were')} successfully created."
		else
			flash[:notice] = 'No titles were submitted so no assets were created.'
		end
		redirect_to(assets_path)
	rescue
		flash.now[:error] = 'Asset creation failed.'
		render :action => "batch_new"
	end

#	def temporary_batch_create
#		new_assets_count = 0
#		lines = 0
#		params[:assets].split("\n").each do |line|
#			lines += 1
#			line = line.chomp
#			p = line.split('|')
##			if p[4].blank?
##				puts "\n\nThe title is blank for asset ...\n #{line}\n\n"
##			end
#			next if p[4].blank?
#			used = (p[7] =~ /Yes|No|lost|reading/i) ? Date.today.to_s : p[7]
##			acquired = (p[8] =~ /Yes/i) ? Date.today.to_s : p[8]
#			@asset = current_user.assets.build({
#				:category_names => [p[0],p[1],p[2],p[5],p[10]].join(';'), 
#				:creator_names => p[3], 
#				:title => p[4], 
#				:location_names => p[6], 
#				:used_on_string => used,
#				:acquired_on_string => p[8],
#				:serial => p[9], 
#				:model => p[10], 
#				:value => p[12], 
#				:cost => p[13],
#				:description => line
#			})
#			@last_asset = line
#			@asset.save!
#			new_assets_count += 1
#		end
#		if new_assets_count > 0
#			flash[:notice] = "#{@template.pluralize(new_assets_count,'asset was', 'assets were')} out of #{lines} successfully created."
#		else
#			flash[:notice] = 'No assets were submitted so none were created.'
#		end
#		redirect_to(assets_path)
#	rescue
#		flash.now[:error] = "#{@template.pluralize(new_assets_count,'asset was', 'assets were')} out of #{lines} successfully cre    ated.\nAsset creation failed at \n#{@last_asset}"
#		render :action => "batch_new"
#	end




	def edit
		@page_title = "Edit Asset"
		store_referer
	end

	def stream_edit
		@page_title = "Edit Asset"
		@ids = current_user.assets.search(params).collect(&:id)
		if @ids.length > 0
			@asset = current_user.assets.find(@ids.shift)
			render :action => 'edit'
		else
			flash[:error] = "No assets to edit"
			redirect_to(request.env["HTTP_REFERER"]||assets_url)
		end
	end

	def update
		@asset.update_attributes!(params[:asset])
		flash[:notice] = 'Asset was successfully updated.'
		if params[:ids].blank?
#			redirect_to_referer_or_default(@asset)	
#	if editting 2 separate, only remembers LAST referer so redirect is wrong!
#	Application only has 1 "session[:refer_to]".
#	Might be nice to have a page/tab specific referer

			redirect_to(@asset)
		else
			@ids = params[:ids].split(',')
			@asset = current_user.assets.find(@ids.shift)
			render :action => 'edit'
		end
	rescue
		@ids = params[:ids].split(',') if !params[:ids].blank?
		flash.now[:error] = 'Asset update failed.'
		render :action => "edit"
	end

	def destroy
		@asset.destroy
		respond_to do |format|
			format.html { redirect_to(request.env["HTTP_REFERER"]||assets_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@asset)
				end
			end
		end
	end

protected

	def get_asset
		@asset = Asset.find(params[:id])
		#	adding the user will raise errors in all the testing
		#	this means that admin users couldn't access them
		#	perhaps more secure?
		#	perhaps add a rescue?
		#	can I rescue in a rescue?
#		@asset = current_user.assets.find(params[:id])
	end

	def require_asset_owner
		unless ( logged_in? && ( ( current_user.id == @asset.user.id ) || current_user.has_role?('administrator') ) )
			permission_denied("Sorry, but this is not your asset")
		end
	end

	def require_asset_for_sale
		unless ( @asset.for_sale ||
			( logged_in? && ( ( current_user.id == @asset.user.id ) || current_user.has_role?('administrator') ) ) )
			permission_denied("Sorry, but this is asset is not for sale")
		end
	end

end

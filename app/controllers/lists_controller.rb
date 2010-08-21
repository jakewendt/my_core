class ListsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	# lists are 100% private (NOT ANYMORE)
	before_filter :login_required, :except => [ :show ]
	before_filter :get_list, :except => [ :index, :new, :create ]
	# requires current_user and @list
	before_filter :require_owner, :except => [ :new, :create, :show, :index ]
	before_filter :check_list_public, :only => [ :show ]
	before_filter :check_pdf_download, :only => [ :index ]

	def confirm_destroy
	end

	def index
		@page_title = "Lists"
		@lists = List.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=lists_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		@page_title = @list.title
		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=list_#{@list.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.pdf { prawnto :filename => "list_#{@list.id}_#{Time.now.to_s(:filename)}.pdf" } #{ download_pdf(@list) }
		end
	end

	def copy
		new_list = current_user.lists.create!(@list.attributes)
		@list.items.each do |i|
			new_list.items << new_list.items.create!(i.attributes)
		end
		@list = new_list
		flash[:notice] = 'List was successfully copied.'
		redirect_to edit_list_url(@list)
	rescue ActiveRecord::RecordInvalid
#
#	if items.create! fails, the new list will still exist
#
		flash[:error] = "List copy failed"
		render :action => "show"
	end

	def convert_to_note
		@note = current_user.notes.build({
			:title => @list.title,
			:body  => @list.description
		})
		@note.body << "\n\nIncomplete\n\n"
		@list.items.incomplete.each { |i| @note.body << "#{i.content}\n" }
		@note.body << "\n\nComplete\n\n"
		@list.items.complete.each	 { |i| @note.body << "#{i.content}\n" }
		@note.save!
		flash[:notice] = 'List was successfully converted to note.'
		redirect_to edit_note_url(@note)
	rescue ActiveRecord::RecordInvalid
		flash[:error] = "List conversion failed"
		render :action => "show"
	end

	def new
		@page_title = "Create New List"
		@list = List.new
	end

	def create
		@list = current_user.lists.new(params[:list])
		@list.save!
		flash[:notice] = 'List was successfully created.'
		redirect_to(@list)
	rescue
		flash.now[:error] = 'List creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit " + @list.title
	end

	def update
		#	changed lists to use accepts_nested_attributes_for :incomplete_items
		#	making this o so much simpler
		if @list.update_attributes(params[:list]) 
			redirect_to @list
		else
			flash.now[:error] = 'List update failed.'
			render :action => 'edit'
		end 
	end

	def destroy
		@list.destroy
		respond_to do |format|
			format.html { redirect_to(lists_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@list)
					# list_count doesn't get updated immediately?? so use lists.count
					page << "if ( jQuery('#lists_count') ) {"
					page.replace_html "lists_count", @list.user.lists.count
					page << "}"
				end
			end
		end
	end

	def mark_all_complete
		@list.items.incomplete.update_all('completed = true')
		redirect_to @list
	end

	def mark_all_incomplete
		@list.items.complete.update_all('completed = false')
		redirect_to @list
	end

protected

	def get_list
		@list = List.find( params[:id], :include => :items )
	end

	def check_list_public
		check_public(@list)
	end

end

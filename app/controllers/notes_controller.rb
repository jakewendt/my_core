class NotesController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :show ]
	before_filter :get_note, :except => [ :index, :new, :create ]
	# requires current_user and @note
	before_filter :require_owner, :except => [ :new, :create, :show, :index ]
	before_filter :check_note_public, :only => [ :show ]
	before_filter :check_pdf_download, :only => [ :index ]

	def confirm_destroy
	end

	def copy
		new_note = current_user.notes.create!(@note.attributes)
		@note = new_note
		flash[:notice] = 'Note was successfully copied.'
		redirect_to edit_note_url(@note)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Note copy failed"
		render :action => "show"
	end

	def convert_to_list
		@list = current_user.lists.create!({
			:title			 => @note.title, 
			:description => ""
		})
		@note.body.split("\n").each do |line|
			if !line.blank?
				@list.items.create!(:content => line)
			end
		end
		flash[:notice] = 'Note was successfully converted to list.'
		redirect_to edit_list_url(@list)
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = "Note conversion failed"
		render :action => "show"
	end

	def index
		@page_title = "Notes"
		@notes = Note.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
		respond_to do |format|
			format.html
			format.txt { 
				headers["Content-disposition"] = "attachment; filename=notes_#{Time.now.to_s(:filename)}.txt" 
			}
		end
	end

	def show
		@page_title = @note.title
		respond_to do |format|
			format.html
			format.txt { 
				headers["Content-disposition"] = "attachment; filename=note_#{@note.id}_#{Time.now.to_s(:filename)}.txt" 
			}
			format.pdf { prawnto :filename => "note_#{@note.id}_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

	def new
		@page_title = "Create New Note"
		@note = Note.new
	end

	def create
		@note = current_user.notes.new(params[:note])
		@note.save!
		flash[:notice] = 'Note was successfully created.'
		redirect_to(@note)
	rescue
		flash.now[:error] = 'Note creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit " + @note.title
	end

	def update
		@note.update_attributes!(params[:note])
		flash[:notice] = 'Note was successfully updated.'
		redirect_to(@note)
	rescue
		flash.now[:error] = 'Note update failed.'
		render :action => "edit"
	end

	def destroy
		@note.destroy
		respond_to do |format|
			format.html { redirect_to(notes_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@note)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#notes_count') ) {"
					page.replace_html "notes_count", @note.user.notes.count
					page << "}"
				end
			end
		end
	end

protected

	def get_note
		@note = Note.find(params[:id])
	end

	def check_note_public
		check_public(@note)
	end

end

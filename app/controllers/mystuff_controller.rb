class MystuffController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required

	def index
		@page_title = "My Stuff"
		@user = current_user

#	This doesn't work in testing.  Testing actually sets the HTTP_ACCEPT, but I don't actually
#	test the contents so it may not matter.
#	format-txt-
#	HTTP_ACCEPT:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
#	In actual use, it does work

#	puts does not work on hostingrails because its in the background dummy!
#logger.info "Testing logger 2"

		if params[:format] && %w(txt pdf).include?(params[:format])
			@boards = @user.boards
			@blogs = @user.blogs
			@lists = @user.lists
			@notes = @user.notes
			@resumes = @user.resumes
			@trips = @user.trips
		else
			@boards = @user.boards.search(params)
			@blogs = @user.blogs.search(params)
			@lists = @user.lists.not_hidden.search(params)
			@notes = @user.notes.not_hidden.search(params)
			@resumes = @user.resumes.search(params)
			@trips = @user.trips.search(params)
		end

		respond_to do |format|
			format.html
			format.txt {
				headers["Content-disposition"] = "attachment; filename=mystuff_#{Time.now.to_s(:filename)}.txt"
			}
			format.pdf { prawnto :filename => "mystuff_#{Time.now.to_s(:filename)}.pdf" }
		end
	end

end

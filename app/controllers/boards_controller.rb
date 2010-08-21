class BoardsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	before_filter :login_required, :except => [ :show ]
	before_filter :get_board, :except => [ :index, :new, :create ]
	# requires current_user and @board
	before_filter :require_owner, :only => [ :edit, :update, :confirm_destroy, :destroy ]
	before_filter :check_board_public, :only => [ :show ]

	def confirm_destroy
	end

	def index
		@page_title = "Magnetic Poetry Boards"
		@boards = Board.public_and_mine(current_user).search(params).paginate({
			:page => params[:page], 
			:per_page => params[:per_page]||PER_PAGE
		})
	end

	def show
		@page_title = @board.title
		positions = @board.magnets.collect(&:position)
		#	position is a new attribute so deal with any that are 0
		if positions.include?(0) or positions.find_all{|p|p>positions.length}.length > 0
			@board.magnets.each_with_index{|m,i|m.update_attribute(:position,i+1)}
		end
		render :layout => "showboard"
	end

	def new
		@board = Board.new
	end

	def create
		@board = current_user.boards.new(params[:board])
		@board.save!
		flash[:notice] = 'Board was successfully created.'
		redirect_to(edit_board_url(@board))
	rescue ActiveRecord::RecordInvalid
		flash.now[:error] = 'Board creation failed.'
		render :action => "new"
	end

	def edit
		@page_title = "Edit " + @board.title
	end

	def update
		#	changed boards to use accepts_nested_attributes_for :magnets
		#	making this o so much simpler
		if @board.update_attributes(params[:board])
			redirect_to @board
		else
			flash.now[:error] = "An error occured updating this board."
			render :action => 'edit'
		end
	end

#	def original_update
#		# Found this method online at ...
#		# http://wiki.rubyonrails.org/rails/pages/HowToUpdateModelsWithHasManyRelationships
#		# What's the practical difference here between .collect or .each
#		update_result = @board.update_attributes(params[:board])
##		@board.magnets.collect do |magnet|
#		@board.magnets.each_with_index do |magnet,i|
#			# I don't understand why I need this "if"
#			# If there aren't any magnets, it shouldn't be here?
#			if params[:magnet]
#				result = magnet.update_attributes( params[:magnet][magnet.id.to_s] )
#				update_result &&= result
#			end
#		end
##	TODO
##	cleanup
##		respond_to do |format|
##			format.html do
#				if update_result
#					redirect_to @board
#				else
#					flash.now[:error] = "An error occured updating this board."
#					render :action => 'edit'
#				end
##			end
##			format.js {}
##		end
#	end

	def destroy
		@board.destroy
		respond_to do |format|
			format.html { redirect_to(boards_url) }
			format.js do
				render :update do |page|
					page.remove dom_id(@board)
					# _count doesn't get updated immediately??
					page << "if ( jQuery('#boards_count') ) {"
					page.replace_html "boards_count", @board.user.boards.count
					page << "}"
				end
			end
		end
	end

protected

	def get_board
		@board = Board.find(params[:id], :include => :magnets)
	end

	def check_board_public
		check_public(@board)
	end

end

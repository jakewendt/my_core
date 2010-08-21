class ItemsController < ApplicationController
	#	index, show, new, edit, create, update, destroy
	# lists are 100% private
	before_filter :login_required
	before_filter :get_list_and_items #, :except => [ :index, :new, :create ]
	# requires current_user and @list
	before_filter :require_owner

	def create
		params[:item] ||= { :content => 'New Item' }
		params[:item][:content] ||= 'New Item'
		@item = @list.items.new(params[:item])
		saved = @item.save
		respond_to do |format|
			format.html do
				if saved
					flash[:notice] = 'Item created!'
				else
					flash[:error] = 'Item creation FAILED!'
				end
				redirect_to @list
			end
			format.js do
				render :text => '' unless saved
			end
		end
	end

	def update	#	marking complete or incomplete
#	TODO
#	add a respond_to block
		@item.update_attributes!(params[:item])
		@item.move_to_bottom
	rescue
		flash.now[:error] = 'Item update failed.'
#		render :action => "edit"
		render :text => ''
	end

	def order
#	This isn't as effective as once thought.	Somehow I have ended up
#	with multiple items at the same position
#		params[:items].each { |id| @list.items.find(id).move_to_bottom }
		params[:items].each_with_index { |id,i| Item.find(id).update_attribute(:position,i+1) }
		respond_to do |format|
#	TODO
#			format.html {}
			format.js { render :text => '' }
		end
	end 

protected

	def get_list_and_items
		if( params[:list_id] )
			@list	= List.find( params[:list_id], :include => :items )
			@items = @list.items
			@item	= @items.find(params[:id]) if params[:id]
		else
			@item	= Item.find(params[:id])
			@list = @item.list
		end
	end

end

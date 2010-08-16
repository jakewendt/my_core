ActionController::Routing::Routes.draw do |map|
  map.resource :mine_sweeper, :only => [:new, :show]	#	no index action and no :id
  map.resource :blackjack, :only => :show
  map.resource :yahtzee, :only => :show
  map.resource :rip_ratings

  map.resources :connect_fours

  map.resources :tic_tac_toes

  map.resources :messages

  map.resources :downloads, :except => [:new], :member => { 
		:download => :get, 
		:confirm_destroy => :get 
	}

#
# Railscasts Ep 79
#
#	def map.controller_actions(controller, actions)
#		actions.each do |action|
#			self.send("#{controller}_#{action}", "#{controller}/#{action}", :controller => controller, :action => action)
#		end
#	end
#	map.resources :products, :categories
#	map.controller_actions 'about', %w[company privacy license]
#
# The following just seems wrong.	I just want to add the selected routes
# but it almost seems that rake routes creates duplicate routes for the
# entire controller.
#
#	%w[stops entries].each do |controller|
#		map.resources controller, :member => { :create_comment => :post }
#	end
#	
#	%w[stops entries].each do |controller|
#		map.resources controller, :member => {
#			:create_photo	 => :post,
#			:attach_photo	 => :post,
#			:detach_photo	 => :post
#		}
#	end
	

	map.root :controller => "pages", :action => "show", :path => ["home"]
	map.signup   '/signup', :controller => 'users',		:action => 'new'
	map.signin   '/signin', :controller => 'sessions', :action => 'new'
	map.login	   '/login',	:controller => 'sessions', :action => 'new'
	map.logout   '/logout', :controller => 'sessions', :action => 'destroy'
	map.activate '/activate/:id', :controller => 'accounts', :action => 'show'
	map.forgot_password '/forgot_password',		:controller => 'passwords', :action => 'new'
	map.reset_password	'/reset_password/:id', :controller => 'passwords', :action => 'edit'
	map.change_password '/change_password',		:controller => 'accounts',	:action => 'edit'
	map.compose '/compose', :controller => 'emails', :action => 'new'
# send is an illegal route name.	Not needed anyway as user won't ever see this url.
#	map.send		'/send',		:controller => 'messages', :action => 'create'

	
  map.resources :for_sale, :only => [ :show, :index ]
  map.resources :assets, :collection => { 
		:stream_edit => :get,
		:batch_new => :get,
		:batch_create => :post
	}, :member => { :confirm_destroy => :get }
  map.resources :creators,   :except => [ :new, :create ], :member => { :confirm_destroy => :get }
  map.resources :locations,  :except => [ :new, :create ], :member => { :confirm_destroy => :get }
  map.resources :categories, :except => [ :new, :create ], :member => { :confirm_destroy => :get }

	map.resources :pages, :member => { 
		:confirm_destroy => :get,
		:show_position => :get, 
		:move_higher => :put, 
		:move_lower => :put 
	}
 
	map.resources :boards, :shallow => true, :member => { :confirm_destroy => :get } do |board|
		board.resources :magnets, :only => [:create,:update],
			:member => { :confirm_destroy => :get }
	end

	map.resources :resumes, :shallow => true, :member => { :confirm_destroy => :get } do |resume|
		resume.resources :skills, :collection => { :order => :post }, :only => [:create]
		resume.resources :jobs, :only => [:create]
		resume.resources :schools, :only => [:create]
		resume.resources :affiliations, :only => [:create]
		resume.resources :publications, :only => [:create]
		resume.resources :languages, :collection => { :order => :post }, :only => [:create]
	end

	map.resources :lists, 
		:shallow => true,
		:member => { 
			:mark_all_complete => :get, 
			:mark_all_incomplete => :get, 
			:confirm_destroy => :get, 
			:copy => :get, 
			:convert_to_note => :get 
		} do |list|
			list.resources :items, 
				:except => [:new,:edit,:show,:index,:destroy], 
				:member => { :confirm_destroy => :get },
				:collection => { :order => :post }
	end

	map.resources :blogs, :shallow => true, :member => { :confirm_destroy => :get } do |blog|
		blog.resources :entries, :except => [:index], :member => { 
				:confirm_destroy => :get,
				:attach_photo	 => :post,
				:detach_photo	 => :post,
				:create_photo	 => :post,
				:create_comment => :post 
		} do |entry|
			entry.resources :photos, :member => { :confirm_destroy => :get }
		end
	end

	map.resources :forums, :shallow => true do |forum| 
		forum.resources :topics do |topic| 
			topic.resources :posts 
		end 
	end 

	map.resources :users, :member => { :enable => :put } do |user|
		user.resource  :account, :only => [ :show, :edit, :update ]
#
#	TODO
#	This should really be a user_roles route since roles are not really the target of operation here.
#
		user.resources :roles, :only => [:index,:update,:destroy]
		user.resources :photos, :member => { :confirm_destroy => :get }
	end
	
	map.resources :trips, :shallow => true, :member => { :confirm_destroy => :get } do |trip|
		trip.resources :stops, :except => [:create,:index], :collection => { :order => :post },
			:member => {
				:confirm_destroy => :get,
				:create_photo	 => :post,
				:attach_photo	 => :post,
				:detach_photo	 => :post,
				:create_comment => :post, 
				:update_latlng	=> :put
			} do |stop|
			stop.resources :photos, :member => { :confirm_destroy => :get }
		end
	end

	map.resources :notes, 
		:member => { :copy => :get, :convert_to_list => :get, :confirm_destroy => :get }

	map.resources :comments, :only => [ :edit, :update, :destroy ]	 # isolated when changed to acts_as_commentable
	map.resources :photos, :member => { :create_comment => :post, :confirm_destroy => :get }
	map.resource :session, :only => [ :new, :create, :destroy ]
	map.resource :password, :only => [ :new, :create, :edit, :update ]
	map.resources :emails, :only => [ :new, :create ]

# by being singular the index path is not mystuffs_path, its mystuff_index
#	map.resources :mystuff
	map.mystuff '/mystuff.:format', :controller => 'mystuff',		:action => 'index'

#	I'd like to do this more cleanly, but this seems to work.
#	map.dynamic '/dynamic.:format', :controller => 'javascripts', :action => 'dynamic', :format => 'js'
#	map.resources :javascripts, :only => [], :collection => { 
#		:connect_four => :get,
#		:tic_tac_toe => :get,
#		:board   => :get,
#		:list    => :get,
#		:dynamic => :get 
#	}
	map.connect 'javascripts/:action.:format', :controller => 'javascripts'

# needed for /rails/info/properties
#	map.connect ':controller/:action/:id'

#
#	created this catch all route so that /home or /about work
#	Now I can add pages like help_blog or help_javascrypt
#	I can also add /help/blog which works as expected since no
#	help controller actually exists
#	Of course, these pages need to be hard coded into the app which can be a bad thing.
#		For testing, I'll probably have to create fixtures for all of the expected pages.
#		Add also create a better response, than an exception, to when pages don't exist.
#
#	actually /help/test generates "path"=>["help", "test"] which will require a modification
#	to the existing Page.find code in the controller
#
#	I am alse going to need to add a unique index to the page model title
#
	map.connect '*path', :controller => 'pages', :action => 'show'

end

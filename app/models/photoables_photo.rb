class PhotoablesPhoto < ActiveRecord::Base
	# In my opinion, PhotoablesPhoto seems to be misnamed
	# but it is required, so ...
	belongs_to :photo
	belongs_to :photoable, :polymorphic => true
	# , :counter_cache => true	# uses photoables_photos_count which isn't really what I want

	validates_presence_of :photo
	validates_presence_of :photoable

	#	This will probably need renamed to PhotoablePhoto
	#	after removing has_many_polymorphs

end

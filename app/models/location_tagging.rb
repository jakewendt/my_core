class LocationTagging < ActiveRecord::Base
	belongs_to :asset
	belongs_to :location, :counter_cache => :assets_count
end

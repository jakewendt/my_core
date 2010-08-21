class CreatorTagging < ActiveRecord::Base
	belongs_to :asset
	belongs_to :creator, :counter_cache => :assets_count
end

class CategoryTagging < ActiveRecord::Base
	belongs_to :asset
	belongs_to :category, :counter_cache => :assets_count
end

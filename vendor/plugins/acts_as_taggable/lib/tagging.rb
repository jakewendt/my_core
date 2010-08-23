class Tagging < ActiveRecord::Base
	belongs_to :taggable, :polymorphic => true
	belongs_to :tag, :counter_cache => :taggables_count
end

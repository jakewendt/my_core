class AddLinkSetsCountToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :link_sets_count, :integer, :default => 0
	end

	def self.down
		remove_column :users, :link_sets_count
	end
end

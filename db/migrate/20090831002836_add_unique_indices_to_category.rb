class AddUniqueIndicesToCategory < ActiveRecord::Migration
	def self.up
		add_index :categories, [:name,:user_id], :unique => true, :name => 'by_name'
	end

	def self.down
		remove_index :categories, :name => 'by_name'
	end
end

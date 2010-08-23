class AddUniqueIndicesToRole < ActiveRecord::Migration
	def self.up
		add_index :roles, :name, :unique => true, :name => 'by_name'
	end

	def self.down
		remove_index :roles, :name => 'by_name'
	end
end

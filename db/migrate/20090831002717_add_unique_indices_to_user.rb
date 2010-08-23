class AddUniqueIndicesToUser < ActiveRecord::Migration
	def self.up
		add_index :users, :login, :unique => true, :name => 'by_login'
		add_index :users, :email, :unique => true, :name => 'by_email'
	end

	def self.down
		remove_index :users, :name => 'by_login'
		remove_index :users, :name => 'by_email'
	end
end

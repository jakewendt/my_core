class AddUniqueIndicesToPage < ActiveRecord::Migration
	def self.up
		add_index :pages, :path, :unique => true, :name => 'by_path'
	end

	def self.down
		remove_index :pages, :name => 'by_path'
	end
end

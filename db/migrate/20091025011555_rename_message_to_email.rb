class RenameMessageToEmail < ActiveRecord::Migration
	def self.up
		rename_table :messages, :emails
	end

	def self.down
		rename_table :emails, :messages
	end
end

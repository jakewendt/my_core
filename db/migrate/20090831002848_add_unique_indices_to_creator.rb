class AddUniqueIndicesToCreator < ActiveRecord::Migration
	def self.up
		add_index :creators, [:name,:user_id], :unique => true, :name => 'by_name'
	end

	def self.down
		remove_index :creators, :name => 'by_name'
	end
end

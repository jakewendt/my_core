class AddUniqueIndicesToLocation < ActiveRecord::Migration
	def self.up
		add_index :locations, [:name,:user_id], :unique => true, :name => 'by_name'
	end

	def self.down
		remove_index :locations, :name => 'by_name'
	end
end

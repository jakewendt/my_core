class AddPositionToMagnets < ActiveRecord::Migration
	def self.up
		add_column :magnets, :position, :integer, :default => 0
	end

	def self.down
		remove_column :magnets, :position
	end
end

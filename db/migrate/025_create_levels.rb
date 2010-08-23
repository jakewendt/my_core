class CreateLevels < ActiveRecord::Migration
	def self.up
		create_table :levels do |t|
			t.string	:name, :null => false
			t.integer :value, :null => false, :default => 0
		end
#		Level.create({ :name => 'Beginner',		 :value => 1 })
#		Level.create({ :name => 'Novice',			 :value => 2 })
#		Level.create({ :name => 'Intermediate', :value => 3 })
#		Level.create({ :name => 'Advanced',		 :value => 4 })
#		Level.create({ :name => 'Expert',			 :value => 5 })
	end

	def self.down
		drop_table :levels
	end
end

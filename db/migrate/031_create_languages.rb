class CreateLanguages < ActiveRecord::Migration
	def self.up
		create_table :languages do |t|
			t.integer :resume_id, :null => false
			t.integer :level_id,  :null => true		#	why null true?
			t.integer :position,  :null => false, :default => 0
			t.string  :name,      :default => '', :null => true		#	why null true?
			t.timestamps
		end
		add_column :resumes, :languages_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :languages
		remove_column :resumes, :languages_count
	end
end

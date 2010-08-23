class CreateSkills < ActiveRecord::Migration
	def self.up
		create_table :skills do |t|
			t.integer :resume_id, :null => false
			t.integer :level_id,  :null => true		#	why null true?
			t.integer :position,  :null => false, :default => 0
			t.string  :name,      :default => '', :null => true		#	why null true?
			t.date    :start_date	#, :null => false
			t.date    :end_date
			t.timestamps
		end
		add_column :resumes, :skills_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :skills
		remove_column :resumes, :skills_count
	end
end

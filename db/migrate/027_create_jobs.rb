class CreateJobs < ActiveRecord::Migration
	def self.up
		create_table :jobs do |t|
			t.integer :resume_id,  :null => false
			t.date    :start_date, :null => false
			t.date    :end_date
			t.string  :company,    :null => false
			t.string  :location,   :null => false
			t.string  :title,      :null => false
			t.text    :description
			t.timestamps
		end
		add_column :resumes, :jobs_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :jobs
		remove_column :resumes, :jobs_count
	end
end

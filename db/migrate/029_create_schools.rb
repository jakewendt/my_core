class CreateSchools < ActiveRecord::Migration
	def self.up
		create_table :schools do |t|
			t.integer :resume_id,  :null => false
			t.date    :start_date, :null => false
			t.date    :end_date
			t.string  :name,       :null => false
			t.string  :location,   :null => false
			t.string  :degree
			t.text    :description
			t.timestamps
		end
		add_column :resumes, :schools_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :schools
		remove_column :resumes, :schools_count
	end
end

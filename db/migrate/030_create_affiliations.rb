class CreateAffiliations < ActiveRecord::Migration
	def self.up
		create_table :affiliations do |t|
			t.integer :resume_id,    :null => false
			t.integer :position,     :null => false, :default => 0
			t.date    :start_date,   :null => false
			t.date    :end_date
			t.string  :organization, :null => false
			t.string  :relationship, :null => false
			t.timestamps
		end
		add_column :resumes, :affiliations_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :affiliations
		remove_column :resumes, :affiliations_count
	end
end

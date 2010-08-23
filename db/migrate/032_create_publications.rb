class CreatePublications < ActiveRecord::Migration
	def self.up
		create_table :publications do |t|
			t.integer :resume_id,    :null => false
			t.integer :position,     :null => false, :default => 0
			t.string  :contribution, :null => false
			t.string  :name,         :null => false
			t.string  :title,        :null => false
			t.string  :url
			t.date    :date,         :null => false
			t.timestamps
		end
		add_column :resumes, :publications_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :publications
		remove_column :resumes, :publications_count
	end
end

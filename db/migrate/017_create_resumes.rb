class CreateResumes < ActiveRecord::Migration
	def self.up
		create_table :resumes do |t|
			t.integer :user_id, :null => false
			t.boolean :public, :null => false, :default => false
			t.boolean :hide, :default => false
			t.string  :title
			t.text    :objective
			t.text    :summary
			t.text    :other
			t.timestamps
		end
		add_column :users, :resumes_count, :integer, :null => false, :default => 0
	end

	def self.down
		drop_table :resumes
		remove_column :users, :resumes_count
	end
end

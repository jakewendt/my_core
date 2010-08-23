class CreateDownloads < ActiveRecord::Migration
	def self.up
		create_table :downloads do |t|
			t.references :user
			t.string     :url
			t.string     :status		#	success, failure, other message
#			t.datetime   :queued_at 	#	just use created_at
			t.datetime   :started_at
			t.datetime   :completed_at
			t.timestamps
			t.string     :name
		end
		add_column :users, :downloads_count, :integer, :default => 0, :null => false
	end

	def self.down
		drop_table :downloads
		remove_column :users, :downloads_count
	end
end

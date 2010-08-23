class CreatePhotos < ActiveRecord::Migration
	def self.up
		create_table :photos do |t|
			t.references :user
			t.string     :file
			t.text       :caption
			t.timestamps
		end
	end

	def self.down
		drop_table :photos
	end
end

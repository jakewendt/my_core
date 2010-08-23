class CreatePhotoablesPhotos < ActiveRecord::Migration
	def self.up
		create_table :photoables_photos do |t|
			t.references :photoable, :polymorphic => true
			# generates photoable_id and photoable_type
			t.references :photo
			# generates :photo_id (so why not just add 't.integer :photo_id' ?)
			t.timestamps
		end
	end

	def self.down
		drop_table :photoables_photos
	end
end

class MoveImagesToPhotos < ActiveRecord::Migration
	def self.up
		add_column :images, :user_id, :integer
#	No such thing as an "Image" anymore
#		Image.find(:all).each do |image|
#			image.update_attribute(:user_id, image.stop.trip.user_id)
#		end
		rename_table :photoables_photos, :old_photoables_photos

		create_table :photoables_photos do |t|
			t.references :photoable, :polymorphic => true
			t.references :photo
			t.timestamps
		end

		rename_table :photos, :old_photos
		rename_table :images, :photos
		rename_column :photos, :filename, :file

#		Photo.find(:all).each do |photo|
#			pp = PhotoablesPhoto.create({
#				:photo_id => photo.id,
#				:photoable_type => 'Stop',
#				:photoable_id => photo.stop_id
#			})
#			photo.save
#		end
#	should probably add some conditions here
#		File::rename 'public/photo', 'public/photo_old'
#		File::rename 'public/image/filename', 'public/image/file'
#		File::rename 'public/image', 'public/photo'
	end

	def self.down
#		File::rename 'public/photo/file', 'public/photo/filename'
#		File::rename 'public/photo', 'public/image'
#		File::rename 'public/photo_old', 'public/photo'

		rename_column :photos, :file, :filename
		rename_table :photos, :images
		rename_table :old_photos, :photos

		drop_table :photoables_photos
		rename_table :old_photoables_photos, :photoables_photos
		remove_column :images, :user_id
	end

end

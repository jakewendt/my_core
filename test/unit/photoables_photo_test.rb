require File.dirname(__FILE__) + '/../test_helper'

class PhotoablesPhotoTest < ActiveSupport::TestCase

	test "should create photoablesphoto" do
		assert_difference 'PhotoablesPhoto.count' do
			photoablesphoto = create_photoablesphoto
			assert !photoablesphoto.new_record?, "#{photoablesphoto.errors.full_messages.to_sentence}"
		end
	end

	test "should require photo" do
		assert_no_difference 'PhotoablesPhoto.count' do
			photoablesphoto = create_photoablesphoto(:photo => nil)
			assert photoablesphoto.errors.on(:photo)
		end
	end

	test "should require photoable" do
		assert_no_difference 'PhotoablesPhoto.count' do
			photoablesphoto = create_photoablesphoto(:photoable => nil)
			assert photoablesphoto.errors.on(:photoable)
		end
	end

protected

	def create_photoablesphoto(options = {} )
		record = PhotoablesPhoto.new({ 
			:photo		 => Photo.create(),
			:photoable => Entry.create({:name => "Name",:body=>"Description"})
#			:photo_id			 => 1,
#			:photoable_id	 => 1,
#			:photoable_type => 'Entry'
		}.merge(options))
		record.save
		record
	end

end

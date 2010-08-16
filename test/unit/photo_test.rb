require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < ActiveSupport::TestCase

	test "should create photo" do
		assert_difference 'Photo.count' do
			photo = create_photo
			assert !photo.new_record?, "#{photo.errors.full_messages.to_sentence}"
		end
	end

#	test "should require body" do
#		assert_no_difference 'Photo.count' do
#			photo = create_photo(:body => nil)
#			assert photo.errors.on(:body)
#		end
#	end

	test "should require user" do
		assert_no_difference 'Photo.count' do
			photo = create_photo( {}, false )
			assert photo.errors.on(:user_id)
		end
	end

protected

	def create_photo(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:photo,options)
		record.save
		record
	end

end

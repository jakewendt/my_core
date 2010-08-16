require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
	add_taggability_unit_tests "Factory(:note)"
	add_common_search_unit_tests :note

	test "should create note" do
		assert_difference 'Note.count' do
			note = create_note
			assert !note.new_record?, "#{note.errors.full_messages.to_sentence}"
		end
	end

	test "should create note with tags without duplicates" do
		assert_difference('Note.count',1) {
		assert_difference('Tag.count',2) {
		assert_difference('Tagging.count',2) {
			note = create_note({
				:tag_names => "me,you,me,you"
			})
			assert !note.new_record?, "#{note.errors.full_messages.to_sentence}"
		} } }
	end

	test "should require title" do
		assert_no_difference 'Note.count' do
			note = create_note(:title => nil)
			assert note.errors.on(:title)
		end
	end

#	test "should require 4 char title" do
#		assert_no_difference 'Note.count' do
#			note = create_note(:title => 'Hey')
#			assert note.errors.on(:title)
#		end
#	end

	test "should create note without body" do
		assert_difference 'Note.count' do
			note = create_note(:body => nil)
			assert !note.new_record?, "#{note.errors.full_messages.to_sentence}"
		end
	end

	test "should require user" do
		assert_no_difference 'Note.count' do
			note = create_note( {}, false )
			assert note.errors.on(:user_id)
		end
	end

protected

	def create_note(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:note,options)
		record.save
		record
	end

end

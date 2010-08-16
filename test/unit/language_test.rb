require File.dirname(__FILE__) + '/../test_helper'

class LanguageTest < ActiveSupport::TestCase
	add_resume_component_unit_tests :language

	test "should create language" do
		assert_difference 'Language.count' do
			language = create_language
			assert !language.new_record?, "#{language.errors.full_messages.to_sentence}"
			assert_equal language.user, language.resume.user
		end
	end

	test "should require name" do
		assert_no_difference 'Language.count' do
			language = create_language( :name => nil )
			assert language.errors.on(:name)
		end
	end

	test "should require level id" do
		assert_no_difference 'Language.count' do
			language = create_language( :level_id => nil )
			assert language.errors.on(:level_id)
		end
	end

	test "should require resume" do
		assert_no_difference 'Language.count' do
			language = create_language( {}, false )
			assert language.errors.on(:resume_id)
		end
	end

protected

	def create_language(options = {}, addresume = true )
		options[:resume] = nil unless addresume
		record = Factory.build(:language,options)
		record.save
		record
	end

end

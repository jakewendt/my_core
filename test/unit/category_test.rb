require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < ActiveSupport::TestCase

	test "should create category" do
		assert_difference 'Category.count' do
			category = create_category
			assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
		end
	end

	test "should require name" do
		assert_no_difference 'Category.count' do
			category = create_category(:name => nil)
			assert category.errors.on(:name)
		end
	end

	test "should require name not begin with a bang" do
		assert_no_difference 'Category.count' do
			category = create_category(:name => "!bang")
			assert category.errors.on(:name)
		end
	end

	test "should require unique name" do
		assert_difference('Category.count',1) do
			category = create_category({:name => "Test Name", :user_id => 1})
			assert !category.new_record?, "#{category.errors.full_messages.to_sentence}"
			category = create_category({:name => "Test Name", :user_id => 1})
			assert category.errors.on(:name)
		end
	end

	test "should require user" do
		assert_no_difference 'Category.count' do
			category = create_category( :user => nil )
			assert category.errors.on(:user_id)
		end
	end

	test "should find or create" do
		assert_difference( 'Category.count', 1 ) do
			@category1 = Category.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert_no_difference( 'Category.count' ) do
			@category2 = Category.find_or_create({:name => 'Testing', :user_id => 1 })
		end
		assert @category1 == @category2
	end

	test "should raise error if multiple named categories" do
		category1 = create_category(:name => 'Testing')
		category2 = create_category(:name => 'Testing')
		assert_no_difference( 'Category.count' ) do
			assert_raises(Category::MultipleCategoriesFound){Category.find_or_create(:name => 'Testing')}
		end
	end

protected

	def create_category(options = {})
		record = Factory.build(:category,options)
		record.save
		record
	end

end

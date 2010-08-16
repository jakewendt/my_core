require File.dirname(__FILE__) + '/../test_helper'

class AssetTest < ActiveSupport::TestCase
#	add_common_search_unit_tests :asset

	test "should create asset" do
		assert_difference 'Asset.count' do
			asset = create_asset
			assert !asset.new_record?, "#{asset.errors.full_messages.to_sentence}"
			assert asset.user.reload.assets_count == 1
		end
	end

	test "should create asset with tags" do
		assert_difference('Asset.count',1) {
		assert_difference('Category.count',2) {
		assert_difference('CategoryTagging.count',2) {
		assert_difference('Creator.count',2) {
		assert_difference('CreatorTagging.count',2) {
		assert_difference('Location.count',1) {
		assert_difference('LocationTagging.count',1) {
			asset = create_asset({
				:category_names => "dvd,movie",
				:location_names => "home",
				:creator_names => "me,you"
			})
			assert !asset.new_record?, "#{asset.errors.full_messages.to_sentence}"
		} } } } } } }
	end

	test "should require title" do
		assert_no_difference 'Asset.count' do
			asset = create_asset(:title => nil)
			assert asset.errors.on(:title)
		end
	end

	test "should require user" do
		assert_no_difference 'Asset.count' do
			asset = create_asset( :user => nil )
			assert asset.errors.on(:user_id)
		end
	end

	test "should search by taggings" do
		assert_difference('Asset.count',3) do
			create_asset({:category_names => "cat1", :creator_names => "me", :location_names => "here"})
			create_asset({:category_names => "cat1,cat2", :creator_names => "me", :location_names => "there"})
			create_asset({:category_names => "cat1,cat3", :creator_names => "you", :location_names => "here"})
		end
		#	Searches use LIKE % % so 'here' matches 'there'
		#	Not using LIKE anymore, so partial matches will fail
		assert Asset.search({:category => 'cat1'}).length == 3
		assert Asset.search({:creator  => 'me'}).length == 2
		assert Asset.search({:location => 'here'}).length == 2
		assert Asset.search({:location => 'there'}).length == 1
		assert Asset.search({:location => 'nowhere'}).length == 0
		assert Asset.search({:category => 'cat1', :creator  => 'me', :location => 'here'}).length == 1
	end

	test "should search by category" do
		assert_difference('Asset.count',3) do
			create_asset({:category_names => "cat1"})
			create_asset({:category_names => "cat1,cat2"})
			create_asset({:category_names => "cat1,cat3"})
		end
		assert_equal 3, Asset.search({:category => 'cat1'}).length
		assert_equal 1, Asset.search({:category => 'cat2'}).length
		assert_equal 1, Asset.search({:category => 'cat1,cat2'}).length
		assert_equal 2, Asset.search({:category => 'cat1,!cat2'}).length
	end

	test "should search by title" do
		assert_difference('Asset.count',3) do
			create_asset({:title => "Name 1"})
			create_asset({:title => "Name 2"})
			create_asset({:title => "Name 3"})
		end
		assert Asset.search({:title => 'Name'}).length == 3
		assert Asset.search({:title => '1'}).length == 1
	end

	%w( category creator location ).each do |tag_name|
		test "should decrement assets_count when #{tag_name} tagging removed" do
			asset = create_asset({"#{tag_name}_names".to_sym => tag_name})
			tag = tag_name.capitalize.constantize.find(:first, :conditions => { :name => tag_name })
			assert_equal 1, tag.assets_count
			assert 1, tag_name.capitalize.constantize.count
			assert 1, "#{tag_name.capitalize}Tagging".constantize.count
			asset.send("#{tag_name}_names=", "")
			asset.save
			asset.reload
			assert 1, tag_name.capitalize.constantize.count
			assert 0, "#{tag_name.capitalize}Tagging".constantize.count
			assert_equal 0, tag.reload.assets_count
		end
	end

protected

	def create_asset(options = {})
		record = Factory.build(:asset,options)
		record.save
		record
	end

end

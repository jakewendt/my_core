require File.dirname(__FILE__) + '/../test_helper'

class ForumTest < ActiveSupport::TestCase

  test "should create forum" do
    assert_difference 'Forum.count' do
      forum = create_forum
      assert !forum.new_record?, "#{forum.errors.full_messages.to_sentence}"
    end
  end

  test "should require name" do
    assert_no_difference 'Forum.count' do
      forum = create_forum(:name => nil)
      assert forum.errors.on(:name)
    end
  end

  test "should require 4 char name" do
    assert_no_difference 'Forum.count' do
      forum = create_forum(:name => 'Hey')
      assert forum.errors.on(:name)
    end
  end

  test "should require description" do
    assert_no_difference 'Forum.count' do
      forum = create_forum(:description => nil)
      assert forum.errors.on(:description)
    end
  end

  test "should require 4 char description" do
    assert_no_difference 'Forum.count' do
      forum = create_forum(:description => 'Hey')
      assert forum.errors.on(:description)
    end
  end

protected

  def create_forum(options = {})
		record = Factory.build(:forum,options)
    record.save
    record
  end

end

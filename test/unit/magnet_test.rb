require File.dirname(__FILE__) + '/../test_helper'

class MagnetTest < ActiveSupport::TestCase

	test "should create magnet" do
		assert_difference 'Magnet.count' do
			magnet = create_magnet
			assert !magnet.new_record?, "#{magnet.errors.full_messages.to_sentence}"
			assert_equal magnet.user, magnet.board.user
		end
	end

	test "should require board" do
		assert_no_difference 'Magnet.count' do
			magnet = create_magnet( {}, false )
			assert magnet.errors.on(:board_id)
		end
	end

protected

	def create_magnet(options = {}, addboard = true )
		options[:board] = nil unless addboard
		record = Factory.build(:magnet,options)
		record.save
		record
	end

end

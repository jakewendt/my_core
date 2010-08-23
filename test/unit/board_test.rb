require File.dirname(__FILE__) + '/../test_helper'

class BoardTest < ActiveSupport::TestCase
	add_taggability_unit_tests "Factory(:board)"
	add_common_search_unit_tests :board

	test "should create board" do
		assert_difference 'Board.count' do
			board = create_board
			assert !board.new_record?, "#{board.errors.full_messages.to_sentence}"
		end
	end

	test "should require title" do
		assert_no_difference 'Board.count' do
			board = create_board(:title => nil)
			assert board.errors.on(:title)
		end
	end

	test "should require 4 char title" do
		assert_no_difference 'Board.count' do
			board = create_board(:title => 'Hey')
			assert board.errors.on(:title)
		end
	end

	test "should require user" do
		assert_no_difference 'Board.count' do
			board = create_board( {}, false )
			assert board.errors.on(:user_id)
		end
	end

	test "should update board with magnets" do
		board = board_with_magnets
		magnets = []
		board.magnets.each do |magnet|
			magnets.push( { :id => magnet.id, :word => "UPDATED #{magnet.word}" } )
		end
		board.update_attributes( { :magnets_attributes => magnets } )
		board.reload.magnets.each do |magnet|
			assert_not_nil magnet.word.match(/^UPDATED /)
		end
	end

	test "should delete magnet on board update" do
		board = board_with_magnets
		magnet = board.magnets.first
#		magnets = [{:id => magnet.id, :_delete => true }]
		magnets = [{:id => magnet.id, :_destroy => true }]
		assert_difference( "Board.find(#{board.id}).magnets.length", -1 ) do
			board.update_attributes( { :magnets_attributes => magnets } )
		end
	end


	test "should update board updated_at on magnet create" do
		board = board_with_magnets
		before = board.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		Factory(:magnet, :board => board)
		after = board.reload.updated_at
		assert_not_equal before, after
	end

	test "should update board updated_at on magnet update" do
		board = board_with_magnets
		before = board.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		board.magnets.first.update_attribute(:word, "New magnet word")
		after = board.reload.updated_at
		assert_not_equal before, after
	end

	test "should update board updated_at on magnet destroy" do
		board = board_with_magnets
		before = board.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		board.magnets.first.destroy
		after = board.reload.updated_at
		assert_not_equal before, after
	end

	test "should update board updated_at on magnet update through nested magnet attributes" do
		board = board_with_magnets
		before = board.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		board.update_attribute(:magnets_attributes, [{
			:id => board.magnets.first.id,
			:word => "UPDATED #{board.magnets.first.word}"
		}])
		after = board.reload.updated_at
		assert_not_equal before, after
	end

	test "should update board updated_at on magnet destroy nested magnet attributes" do
		board = board_with_magnets
		before = board.reload.updated_at
		sleep 1		#	otherwise the new updated_at could be the same as the old
		assert_difference( "Board.find(#{board.id}).magnets.length", -1 ) do
			board.update_attribute(:magnets_attributes, [{
				:id => board.magnets.first.id,
				:_destroy => true
#				:_delete => true
			}])
		end
		after = board.reload.updated_at
		assert_not_equal before, after
	end



protected

	def create_board(options = {}, adduser = true )
		options[:user] = nil unless adduser
		record = Factory.build(:board, options)
		record.save
		record
	end

end

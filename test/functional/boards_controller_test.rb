require File.dirname(__FILE__) + '/../test_helper'

class BoardsControllerTest < ActionController::TestCase

	add_core_tests( :board, :except => [:update_js] )
	add_common_search_tests( :board )

	test "should update board with magnets with owner login" do
		board = board_with_magnets
		login_as board.user
		magnets = []
		board.magnets.each do |magnet|
			magnets.push( { :id => magnet.id, :word => "UPDATED #{magnet.word}" } )
		end
		put :update, :id => board.id, :board => { :magnets_attributes => magnets }
		board.reload.magnets.each do |magnet|
			assert_not_nil magnet.word.match(/^UPDATED /)
		end
		assert_redirected_to board
	end

	test "should destroy magnet with board update with owner login" do
		board = board_with_magnets
		login_as board.user
		magnets = [{:id => board.magnets.first.id, :_delete => true }]
		assert_difference("Board.find(#{board.id}).magnets.length", -1) do
			put :update, :id => board.id, :board => { :magnets_attributes => magnets }
		end
		assert_redirected_to board
	end

	#	tests old boards that didn't have positions
	test "should show board with magnets with positions = 0" do
		Magnet.any_instance.stubs(:position).returns(0)
		board = board_with_magnets
		get :show, :id => board.to_param
		assert_response :success
	end

end

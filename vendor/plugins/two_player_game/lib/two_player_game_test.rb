module TwoPlayerGameTest
	
	def self.included(base)
		base.extend ClassMethods
#		base.instance_eval do
#			include InstanceMethods
#		end
	end
	
	module ClassMethods
		
		def add_two_player_game_unit_tests(game_model)

			test "should create game" do
				assert_difference "#{game_model.to_s.classify}.count" do
					game = create_game
					assert !game.new_record?, "#{game.errors.full_messages.to_sentence}"
					assert [game.player_1_id,game.player_2_id].include?(game.turn_id)
				end
			end

			test "should require player 1" do
				assert_no_difference "#{game_model.to_s.classify}.count" do
					game = create_game(:player_1_id => nil)
					assert game.errors.on(:player_1_id)
				end
			end

			test "should require player 2" do
				assert_no_difference "#{game_model.to_s.classify}.count" do
					game = create_game(:player_2_id => nil)
					assert game.errors.on(:player_2_id)
				end
			end

			test "should require that player 1 is NOT player 2" do
				user = active_user
				assert_no_difference "#{game_model.to_s.classify}.count" do
					game = create_game(:player_1_id => user.id, :player_2_id => user.id)
					assert game.errors.on(:player_2_id)
				end
			end

			test "won_by? should work with symbol player_1" do
				game = create_game
				game.update_attribute(:winner_id, game.player_1_id)
				assert game.won_by?(:player_1)
			end

			test "won_by? should work with symbol player_1_id" do
				game = create_game
				game.update_attribute(:winner_id, game.player_1_id)
				assert game.won_by?(:player_1_id)
			end

			test "won_by? should work with User" do
				game = create_game
				game.update_attribute(:winner_id, game.player_1_id)
				assert game.won_by?(game.player_1)
			end

			test "won_by? should work with user id" do
				game = create_game
				game.update_attribute(:winner_id, game.player_1_id)
				assert game.won_by?(game.player_1_id)
			end

			test "users_turn? should work with symbol player_1" do
				game = create_game
				game.update_attribute(:turn_id, game.player_1_id)
				assert game.users_turn?(:player_1)
			end

			test "users_turn? should work with symbol player_1_id" do
				game = create_game
				game.update_attribute(:turn_id, game.player_1_id)
				assert game.users_turn?(:player_1_id)
			end

			test "users_turn? should work with User" do
				game = create_game
				game.update_attribute(:turn_id, game.player_1_id)
				assert game.users_turn?(game.player_1)
			end

			test "users_turn? should work with user id" do
				game = create_game
				game.update_attribute(:turn_id, game.player_1_id)
				assert game.users_turn?(game.player_1_id)
			end

			test "game_over? should be true if turn_id is nil" do
				game = create_game
				game.update_attribute(:turn_id, nil)
				assert game.game_over?
			end

			test "game_over? should be false if turn_id is nil" do
				game = create_game
				assert !game.game_over?
			end

		end

	end

end

module TwoPlayerGame
	class NotPlayersTurn < StandardError; end
	class GameOver < StandardError; end

	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods

		def two_player_game
			include TwoPlayerGame::InstanceMethods
			extend  TwoPlayerGame::SingletonMethods

#			belongs_to :user, :counter_cache => true
#			validates_presence_of :user_id
#			named_scope :public_and_mine, lambda { |*args| { 
#				:conditions => ["public is true OR #{table_name}.user_id = ?", args.first||0] 
#			} }

			belongs_to :player_1, :class_name => "User"
			belongs_to :player_2, :class_name => "User"
			belongs_to :turn,   :class_name => "User"
			belongs_to :winner, :class_name => "User"

			validates_presence_of :player_1_id
			validates_presence_of :player_2_id

			before_create :set_player_turn

		end
		alias acts_as_two_player_game two_player_game

	end

	module SingletonMethods
	end

	module InstanceMethods

		#	To enable User.find(1).tic_tac_toes.new
		#	the model requires a 'user_id=' method
		def user_id=(user_id)
			self.player_1_id = user_id
		end

		def batter
			turn_id
		end

		def on_deck
			([player_1_id,player_2_id] - [batter])[0]
		end

		def players
			[player_1_id,player_2_id]
		end
		alias player_ids players

		def still_playing?
			!self.turn_id.nil?
		end

		def won?
			!self.winner_id.nil?
		end

		def game_over?
			self.turn_id.nil?
		end

		def won_by?(user)
			self.winner_id == case user			#	same as is_a?
				when User then user.id
				when Symbol then self.send(user).to_param.to_i  # :player_1, :player_1_id, :player_2, :player_2_id
				else user.to_i
			end
		end

		def users_turn?(user)
			self.turn_id == case user			#	same as is_a?
				when User then user.id
				when Symbol then self.send(user).to_param.to_i  # :player_1, :player_1_id, :player_2, :player_2_id
				else user.to_i
			end
		end

	protected

		def set_player_turn
			self.turn_id = [player_1_id,player_2_id][rand(2)]
		end

		def validate
			errors.add(:player_2_id, "is the same as player 1") if player_1_id == player_2_id
		end

	end

end

require 'two_player_game'
ActiveRecord::Base.send(:include, TwoPlayerGame )
Test::Unit::TestCase.send(:include,TwoPlayerGameTest) if RAILS_ENV == 'test'

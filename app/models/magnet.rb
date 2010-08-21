class Magnet < ActiveRecord::Base
	belongs_to :board, :counter_cache => true
	acts_as_list :scope => :board

	validates_presence_of :board_id
	validates_numericality_of :top, :left, :greater_than_or_equal_to => 0

	attr_accessible :word, :top, :left, :position

	delegate :user, :to => :board
	before_save    :update_board_updated_at

	def before_validation_on_create
		self.top = 0
		self.left = 0
	end

	def update_board_updated_at
		#	force updating of updated_at
#		self.list.update_attribute(:updated_at, Time.now)
		self.board.updated_at = Time.now
		self.board.save if self.board.changed?
	end

end

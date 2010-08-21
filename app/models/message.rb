class Message < ActiveRecord::Base
	belongs_to :sender,    :class_name => "User"
	belongs_to :recipient, :class_name => "User"

	validates_presence_of :sender_id
	validates_presence_of :recipient_id
	validates_presence_of :subject

	attr_accessible :recipient_id, :subject, :body

#	# To enable User.find(1).messages.new
#	# the model requires a 'user_id=' method
#	def user_id=(user_id)
#		self.sender_id = user_id
#	end

end

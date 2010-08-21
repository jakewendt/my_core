class Email < ActiveRecord::Base
	belongs_to :sender,		:class_name => "User"
	belongs_to :recipient, :class_name => "User"

	validates_presence_of :sender_id
	validates_presence_of :recipient_id
	validates_presence_of :subject
	validates_presence_of :body

	attr_accessible :recipient_id, :subject, :body

end

require 'digest/sha1'
class User < ActiveRecord::Base

	file_column :image

	# Virtual attribute for the unencrypted password
	attr_accessor :password	

	# prevents a user from submitting a crafted form that bypasses activation
	# anything else you want your user to change should be added here.
	attr_accessible :login, :email, :password, :password_confirmation, :image

# Add ... ?
# name
# address
# phone
#
#

	validates_presence_of		 :login, :email
	validates_presence_of		 :password,									 :if => :password_required?
	validates_presence_of		 :password_confirmation,			:if => :password_required?
	validates_length_of			 :password, :within => 4..40, :if => :password_required?
	validates_confirmation_of :password,									 :if => :password_required?
	validates_length_of			 :login,		:within => 3..40
	validates_length_of			 :email,		:within => 6..100
	validates_uniqueness_of	 :login, :email, :case_sensitive => false
	validates_format_of			 :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
	validates_format_of			 :login, :with => /^\w+$/i, :message => "can be alphanumeric characters only"

	has_and_belongs_to_many :roles
	has_many :trips,	 :order => :title
	has_many :blogs,	 :order => :title
	has_many :boards,	:order => :title
	has_many :lists,	 :order => :title
	has_many :resumes, :order => :title
	has_many :notes,	 :order => :title
	has_many :photos
	has_many :assets,     :order => ignore_articles_in_order_by('title')
	has_many :locations,  :order => ignore_articles_in_order_by('name')
	has_many :creators,   :order => ignore_articles_in_order_by('name')
	has_many :categories, :order => ignore_articles_in_order_by('name')
	has_many :tags, :order => :name
	has_many :downloads, :order => :created_at
	has_many :sent_messages,     :class_name => 'Message', :foreign_key => :sender_id
	has_many :received_messages, :class_name => 'Message', :foreign_key => :recipient_id

#	has_many :messages, :finder_sql => 'SELECT DISTINCT * ' +
#		'FROM messages WHERE sender_id = #{id} OR recipient_id = #{id} ORDER BY created_at DESC'

	#	TicTacToe required an inflection added as rails thought that
	#	the singular of TicTacToes was TicTacTo which is wrong.
	#	And surprisingly the following seems to work.
	has_many :tic_tac_toes, :finder_sql => 'SELECT DISTINCT * ' +
		'FROM tic_tac_toes WHERE player_1_id = #{id} OR player_2_id = #{id} ORDER BY created_at DESC'

	has_many :connect_fours, :finder_sql => 'SELECT DISTINCT * ' +
		'FROM connect_fours WHERE player_1_id = #{id} OR player_2_id = #{id} ORDER BY created_at DESC'


	has_many :comments
	has_many :topics
	has_many :posts

	before_save :encrypt_password
	before_create :make_activation_code


	class ActivationCodeNotFound < StandardError; end
	class AlreadyActivated < StandardError
		attr_reader :user, :message;
		def initialize(user, message=nil)
			@message, @user = message, user
		end
	end

	# Finds the user with the corresponding activation code, activates their account and returns the user.
	#
	# Raises:
	#	+User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
	#	+User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
	def self.find_and_activate!(activation_code)
	raise ArgumentError if activation_code.nil?
		user = find_by_activation_code(activation_code)
	raise ActivationCodeNotFound if !user
	raise AlreadyActivated.new(user) if user.active?
		user.send(:activate!)
		user
	end

	def active?
		# the presence of an activation date means they have activated
		!activated_at.nil?
	end

	# Returns true if the user has just been activated.
	def pending?
		@activated
	end

	# Authenticates a user by their login name and unencrypted password.	Returns the user or nil.
	# Updated 2/20/08
	def self.authenticate(login, password)		
		u = find :first, :conditions => ['login = ?', login] # need to get the salt
		u && u.authenticated?(password) ? u : nil	
	end

	# Encrypts some data with the salt.
	def self.encrypt(password, salt)
		Digest::SHA1.hexdigest("--#{salt}--#{password}--")
	end

	# Encrypts the password with the user salt
	def encrypt(password)
		self.class.encrypt(password, salt)
	end

	def authenticated?(password)
		crypted_password == encrypt(password)
	end

	def remember_token?
		remember_token_expires_at && Time.now.utc < remember_token_expires_at
	end

	# These create and unset the fields required for remembering users between browser closes
	def remember_me
		remember_me_for 2.weeks
	end

	def remember_me_for(time)
		remember_me_until time.from_now.utc
	end

	def remember_me_until(time)
		self.remember_token_expires_at = time
		self.remember_token						= encrypt("#{email}--#{remember_token_expires_at}")
		save(false)
	end

	def forget_me
		self.remember_token_expires_at = nil
		self.remember_token						= nil
		save(false)
	end

	def forgot_password
		@forgotten_password = true
		self.make_password_reset_code
	end

	def reset_password
		# First update the password_reset_code before setting the
		# reset_password flag to avoid duplicate email notifications.
		update_attribute(:password_reset_code, nil)
		@reset_password = true
	end	

	#used in user_observer
	def recently_forgot_password?
		@forgotten_password
	end

	def recently_reset_password?
		@reset_password
	end

	def self.find_for_forget(email)
		find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
	end

	def has_role?(name)
		self.roles.find_by_name(name) ? true : false
	end

	def is_admin?
		self.has_role?('administrator')
	end


protected

	# before filter
	def encrypt_password
		return if password.blank?
		self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
		self.crypted_password = encrypt(password)
	end

	def password_required?
		crypted_password.blank? || !password.blank?
	end

	def make_activation_code
		self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end

	def make_password_reset_code
		self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
	end

#	at some point this'll be some sort of has_many
#	def buddies
#		User.all
#	end

private

	def activate!
		@activated = true
#
#	I think that this is the cause of the duplicate activation emails.
#	The 2 update_attributes trigger 2 after_saves which trigger
#		2 deliveries.
#
#		self.update_attribute(:activated_at, Time.now.utc)
#		self.update_attribute(:activated_email, self.email)
		self.activated_at		= Time.now.utc
		self.activated_email = self.email
		self.save
	end		

end

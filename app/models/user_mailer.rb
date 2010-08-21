class UserMailer < ActionMailer::Base
#
#	Notes about ActionMailer::Base
#		recipients, subject, from, cc, bcc, reply_to are methods that set an instance variable
#			of the same name.  Calling them multiple times destroys previous calls.
#		The body method takes a hash and sets the @body hash.  Again calling it multiple
#			times undoes previous calls so if I need to add keys to this hash I need to modify
#			@body[] explicitly (unless there is a method that I am unaware of.  Perhaps a merge
#			or update.)
#		I suppose there is some OO rule that is being violated here, but it begs the question
#			of why create a method with these restrictions.
#
	def signup_notification(user)
		setup_email(user)
		@subject		<< 'Please activate your new account'	
		@body[:url]	= activate_url(user.activation_code)
	end

	def activation(user)
		setup_email(user)
		@subject		<< 'Your account has been activated!'
		@body[:url]	= root_url
	end

	def forgot_password(user)
		setup_email(user)
		@subject		<< 'You have requested to change your password'
		@body[:url]	= reset_password_url(user.password_reset_code)
	end

	def reset_password(user)
		setup_email(user)
		@subject		<< 'Your password has been reset.'
	end

	def download_ready(download)
		setup_email(download.user)
		@subject		<< 'Your download is ready'
		@body[:url]	= download_download_url(download)
	end

	def email(email)
		recipients User.find(email.recipient_id).email
		from       User.find(email.sender_id).email	
#	I don't know if I can actually set this to users other than my own
#		from       "me@here.com"	#	apparently I can
		reply_to   User.find(email.sender_id).email
		subject    "My JW - " + email.subject
		body(      :user => email.sender, :body => email.body )
	end

#	def email(email)
#		@recipients	= User.find(email.recipient_id).email
#		@from				= User.find(email.sender_id).email
#		@subject		 = "My JW - "
##		@sent_on		 = Time.now
#		@subject		<< email.subject
#		@body[:user] = email.sender
#		@body[:body] = email.body
#	end

protected

	def setup_email(user)
		# still surprised this isn't set somewhere by default ...
		ActionMailer::Base.default_url_options[:host] = "my.jakewendt.com"
		recipients user.email
		admin    = User.find_by_login('admin')
		from       ( (admin) ? admin.email : "jw@jake.otherinbox.com" )
		subject    "My JW - "
		body       :user => user
	end

#	def setup_email(user)
#		# still surprised this isn't set somewhere by default ...
#		ActionMailer::Base.default_url_options[:host] = "my.jakewendt.com"
#		@recipients	= "#{user.email}"
##		@from				= User.find_by_login('admin').email
#		admin				= User.find_by_login('admin')
#		@from				= (admin) ? admin.email : "jw@jake.otherinbox.com"
#		@subject		 = "My JW - "
#		@sent_on		 = Time.now
#		@body[:user] = user
#	end

end

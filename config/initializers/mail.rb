# Email settings
require 'smtp_tls'
#	DO NOT SET THIS HERE OR IT OVERRIDES THE ENVIRONMENT SETTING!
#ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "mail.jakewendt.com",
  :port => 26,
  :domain => "http://my.jakewendt.com",
  :authentication => :plain,
  :user_name => "my@jakewendt.com",
  :password => "n|;6#i2V:}@w"
}
#ActionMailer::Base.smtp_settings = {
#  :address => "smtp.gmail.com",
#  :port => 587,
#  :domain => "http://bellsandwhistles.jakewendt.com",
#  :authentication => :plain,
#  :user_name => "restfulbellsandwhistles@gmail.com",
#  :password => ""  
#}

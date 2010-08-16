# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
#config.cache_classes = false




#
#	http://localhost:3000/entries/6 works the first time, but then
#	fails if you reload on "comment.user.login"
#	comment.user.inspect works though.
#	setting this to true fixes this error but forces restarting the server all the time.
#	I think that this has something to do with plugins, but don't know.
#
#	I copied comment.rb into app/models/ and this error goes away.
#	I'm not adding this to the svn repo so prod will stay the same.
#	I don't quite understand this behaviour.
#
# config.cache_classes = true
config.cache_classes = false





# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true

config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# RAILS_ENV is set to 'development' when using script/server
# so keeping this in development is OK
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

	# sanitize is used on the stop description
	config.action_view.sanitized_allowed_tags = 'a', 'br', 'img'

	config.active_record.observers = :user_observer

	config.gem 'jakewendt-stringify_date',
		:lib    => 'stringify_date', 
		:source => 'http://rubygems.org'

	config.gem 'jakewendt-stringify_time',
		:lib    => 'stringify_time', 
		:source => 'http://rubygems.org'

	config.gem 'jakewendt-ruby_extension',
		:lib    => 'ruby_extension', 
		:source => 'http://rubygems.org'

	config.gem 'ryanb-acts-as-list', 
		:lib => 'acts_as_list', 
		:source => 'http://gems.github.com'

	config.gem 'gravatar'
	config.gem 'jrails'


	config.gem "prawn"
#	config.gem "tidy"
	config.gem "RedCloth"

#	for BackgrounDRb
#	once the backgroundrb plugin is installed, these are required
#	so rake gems:install won't work.
# use MY backgroundrb mod to fix this
	config.gem "packet"
	config.gem "chronic"

#	for juggernaut
	config.gem "json"
	config.gem "eventmachine"
#	config.gem "juggernaut"
#	instructions say install the first, then later the second, but can't figure out
#		how to get the second to work here (although works at command line)
# gem install maccman-juggernaut -s http://gems.github.com
#		ahh ... needs :lib => 'juggernaut'

	#	needs unpacked on hostingrails.com server
	config.gem "maccman-juggernaut", 
		:lib => "juggernaut",
		:source => "http://gems.github.com"


	# Settings in config/environments/* take precedence over those specified here.
	# Application configuration should go into files in config/initializers
	# -- all .rb files in that directory are automatically loaded.

	# Add additional load paths for your own custom dirs
	# config.load_paths += %W( #{RAILS_ROOT}/extras )

	# Specify gems that this application depends on and have them installed with rake gems:install
	# config.gem "bj"
	# config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
	# config.gem "sqlite3-ruby", :lib => "sqlite3"
	# config.gem "aws-s3", :lib => "aws/s3"

	# Only load the plugins named here, in the order given (default is alphabetical).
	# :all can be used as a placeholder for all plugins not explicitly named
	# config.plugins = [ :exception_notification, :ssl_requirement, :all ]

	# Skip frameworks you're not going to use. To use Rails without a database,
	# you must remove the Active Record framework.
	# config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
	config.frameworks -= [ :active_resource ]

	# Activate observers that should always be running
	# config.active_record.observers = :cacher, :garbage_collector, :forum_observer

	# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
	# Run "rake -D time" for a list of tasks for finding time zone names.
	config.time_zone = 'UTC'

	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
	# config.i18n.default_locale = :de
end

#			 %a - The abbreviated weekday name (``Sun'')
#			 %A - The	full	weekday	name (``Sunday'')
#			 %b - The abbreviated month name (``Jan'')
#			 %B - The	full	month	name (``January'')
#			 %c - The preferred local date and time representation
#			 %d - Day of the month (01..31)
#			 %H - Hour of the day, 24-hour clock (00..23)
#			 %I - Hour of the day, 12-hour clock (01..12)
#			 %j - Day of the year (001..366)
#			 %m - Month of the year (01..12)
#			 %M - Minute of the hour (00..59)
#			 %p - Meridian indicator (``AM''	or	``PM'')
#			 %S - Second of the minute (00..60)
#			 %U - Week	number	of the current year,
#							 starting with the first Sunday as the first
#							 day of the first week (00..53)
#			 %W - Week	number	of the current year,
#							 starting with the first Monday as the first
#							 day of the first week (00..53)
#			 %w - Day of the week (Sunday is 0, 0..6)
#			 %x - Preferred representation for the date alone, no time
#			 %X - Preferred representation for the time alone, no date
#			 %y - Year without a century (00..99)
#			 %Y - Year with century
#			 %Z - Time zone name

Time::DATE_FORMATS[:basic] = "%B %d, %Y"		# January 01, 2009
Time::DATE_FORMATS[:month_year] = "%b %Y"	 # Jan 2009
Time::DATE_FORMATS[:month_day] = "%b %d"	 # Jan 01
Time::DATE_FORMATS[:filename] = "%Y%m%d%H%M%S"	 # 20091231235959

Date::DATE_FORMATS[:month_year] = "%b %Y"	 # Jan 2009
Date::DATE_FORMATS[:mdy] = "%b %d, %Y"	 # Jan 01, 2009

ActionController::Base::PER_PAGE = 50

require 'array_extension'
require 'string_extension'
require 'prawn_extension'
require 'common_search'

JUGGERNAUT_ENABLED = false

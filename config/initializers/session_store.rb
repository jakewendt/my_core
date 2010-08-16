# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_my_session',
  :secret      => '46683b28c3a91583fabbcf46edf4f214b0fbe029e197ad2767aeb561eb4486285eba0de9a1c8bf38f98844ebc41e4bbd3ccc3f60dfb4782ca9792758446e7877'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

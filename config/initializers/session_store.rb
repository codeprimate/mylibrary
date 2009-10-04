# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mylibrary_session',
  :secret      => '179a740e4edba887eade2634eaea4c8fee565c16ea6f8f759757381b5f1a03a45a131c0b3c93d378fd1cf2338bb4e24967283036507a71a00376eca367857ddc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

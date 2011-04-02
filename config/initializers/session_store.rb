# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ce_test_session',
  :secret      => '5113a10f7f41560ed99372437bf0dc1d13a399cc1341b26610ca95aa3828d7ca173ec92ca86e85ac2beefd463caecae5b09b9b4373f67618b4de843e347afe46'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store

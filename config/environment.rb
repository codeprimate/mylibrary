RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :action_mailer ]
  config.time_zone = 'UTC'
  config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem "aws-s3", :lib => "aws/s3"
  config.gem "authlogic"
end
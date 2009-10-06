# Capistrano Deploy Recipe for Git and Phusion Passenger
#
# After issuing cap deploy:setup.  Place server specific config files in
#   /home/#{user}/site/[staging|production]/shared
# Set :config_files variable to specify config files that should be
#   copied to config/ directory (i.e. database.yml)
#
# To deploy to staging server:
#  => cap deploy
#  => Deploys application to /home/#{user}/site/staging from master branch
#
# To deploy to production server:
#  =>  cap deploy DEPLOY=PRODUCTION
#  => Deploys application to /home/#{user}/site/production from production branch

### CONFIG: Change ALL of following
set :application, "mylibrary"
set :staging_server, "library.0x42.info"
set :production_server, "library.0x42.info"
set :user, "mylibrary"
set :repository, "git://github.com/codeprimate/mylibrary.git"
set :config_files, %w( database.yml application.yml amazon_s3.yml)
###################################

# System Options
set :use_sudo, false
default_run_options[:pty] = true
set :keep_releases, 3
ssh_options[:forward_agent] = true 

# Git Options
set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :scm_verbose, true

# Deploy type-specific options
if ENV['DEPLOY'] == 'PRODUCTION'
  puts "Deploying to PRODUCTION..."
  server production_server, :app, :web, :db, :primary => true
  set :deploy_target, "production"
  set :branch, "production"
else
  puts "Deploying to STAGING..."
  server staging_server, :app, :web, :db, :primary => true
  set :deploy_target, 'staging'
  set :branch, "master"
end

# Set Deploy path
set :deploy_to, "/home/#{user}/site/#{deploy_target}"

# Deploy Tasks
namespace :deploy do
  
  desc "Copy app config"
  task :after_symlink do
    deploy.config
    deploy.cleanup
  end
      
  desc "Restarting Passenger"
  task :restart, :roles => :app do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
  
  # Stub the Start and Stop Tasks
  [:start, :stop].each do |t|
    desc "#{t} is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Copy Config"
  task :config do
    config_files.each do |c|
      run "touch #{deploy_to}/shared/#{c}"
      run "cp #{deploy_to}/shared/#{c} #{deploy_to}/current/config/" 
    end
  end
end

namespace :watch do
  desc "Tail the production log"
  task :log do
    stream "tail -f #{deploy_to}/shared/log/production.log"
  end
end
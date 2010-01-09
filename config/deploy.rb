set :application, "opening-times.co.uk"

# If you have previously been relying upon the code to start, stop
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

# load 'ext/rails-database-migrations.rb'
# load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/web/public_html/#{application}"

role :app, "#{application}"
role :web, "#{application}"
role :db, "#{application}", :primary => true

default_run_options[:pty] = true
set :repository,  "git@github.com:aubergene/Opening-Times.git"
set :scm, "git"
set :user, "web"

set :branch, "master"
set :deploy_via, :remote_cache

set :use_sudo, false
#set :rake, "/var/lib/gems/1.8/bin/rake"

desc "Link in the production database.yml"
task :after_update_code do
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{deploy_to}/#{shared_dir}/config/recaptcha.rb #{release_path}/config/initializers/recaptcha.rb"
  run "ln -nfs #{deploy_to}/#{shared_dir}/data #{release_path}/data"
  run "ln -nfs #{deploy_to}/#{shared_dir}/export #{release_path}/public/export"
end

#after "deploy:symlink"

#namespace :deploy do
#  task :start, :roles => :app do
#    run "touch #{current_release}/tmp/restart.txt"
#  end

#  task :stop, :roles => :app do
#    # Do nothing.
#  end

#  desc "Restart Application"
#  task :restart, :roles => :app do
#    run "touch #{current_release}/tmp/restart.txt"
#  end

##  desc "Update the crontab file"
##  task :update_crontab, :roles => :db do
##    run "cd #{release_path} && whenever --update-crontab #{application}"
##  end
#end


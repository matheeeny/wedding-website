require "bundler/capistrano"
require "rvm/capistrano"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")

set :user, 'ec2-user'  # Your hosting account's username
set :domain, 'ec2-184-73-81-127.compute-1.amazonaws.com'  # Hosting servername where your account is located
set :project, 'wedding-website'  # Your application as its called in the repository
set :application, 'andrewloveskristen.com'  # Your app's location (domain or subdomain)
set :applicationdir, "/home/#{user}/#{project}"  # The location of your application on your hosting (my differ for each hosting provider)
# version control config
set :scm, 'git'
set :repository,  "git@github.com:matheeeny/wedding-website.git" # Your git repository location
set :deploy_via, :remote_cache
set :git_enable_submodules, 0 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true
# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true
# deploy config
set :deploy_to, applicationdir # deploy to directory set above
set :deploy_via, :export
# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false

set :unicorn_pid do
  "#{shared_path}/pids/unicorn.pid"
end

after 'deploy:update', 'rvm:install_rvm'
after 'deploy:update', 'rvm:install_ruby'
before "deploy:assets:precompile", "bundle:install"

namespace :deploy do
  task :start do
    top.unicorn.start
  end

  task :stop do
    top.unicorn.stop
  end

  task :restart do
    top.unicorn.reload
  end
end

namespace :unicorn do
  desc "start unicorn server"
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn -E #{rails_env} -D -P #{unicorn_pid}"
  end

  desc "stop unicorn server"
  task :stop do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "restart unicorn"
  task :restart do
    top.unicorn.stop
    top.unicorn.start
  end

  desc "reload unicorn (gracefully restart workers)"
  task :reload do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end

  desc "reconfigure unicorn (reload config and gracefully restart workers)"
  task :reconfigure, :roles => :app do
    run "kill -s HUP `cat #{unicorn_pid}`"
  end
end
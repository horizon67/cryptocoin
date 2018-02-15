# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "cryptocoin"
set :repo_url, "git@github.com:horizon67/cryptocoin.git"

set :branch, 'master'
set :deploy_to, "/home/app/cryptocoin"
set :keep_releases, 5
set :rbenv_type, :user
set :rbenv_ruby, '2.4.2'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_path, '/home/app/.rbenv'
set :rbenv_roles, :all
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}
set :linked_files, %w{.env}
set :bundle_binstubs, nil
set :default_stage, "production"
set :log_level, :info
set :yarn_flags, "--prefer-offline --production"
set :yarn_roles, :app

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  #after :finishing, 'deploy:cleanup'
end

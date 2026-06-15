# config/deploy.rb

# Set the Ruby version for rvm
set :rvm_type, :user
set :rvm_ruby, '3.2.2'
set :rvm_path, '/home/ubuntu/.rvm'

# Add the following line to load rvm binaries
set :rvm_map_bins, fetch(:rvm_map_bins, []).push('bundle')

set :repo_url, 'git@github.com:testly-orgs/event_management_app_BE.git'
set :application, 'event-management'
set :user, 'ubuntu'

Rake::Task['deploy:compile_assets'].clear_actions
# Rake::Task['deploy:migrate'].clear_actions

# Don't change these unless you know what you're doing
set :pty, true
set :use_sudo, false # Typically sudo is not needed for deployment
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/app/#{fetch(:application)}"
set :passenger_restart_with_touch, true
set :log_level, :debug
set :linked_files, %w{config/master.key}
set :linked_dirs,  %w{config/credentials log tmp/pids tmp/cache tmp/sockets vendor/bundle}

namespace :deploy do
  desc "Restart Puma"
  task :restart_puma do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, :systemctl, :restart, :puma
    end
  end

  after  :finishing,    :restart_puma
end

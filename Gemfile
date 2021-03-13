# frozen_string_literal: true

source "https://rubygems.org"
ruby '3.0.0'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rails", '~> 6.1.3'
gem 'mysql2'
gem 'pry-rails'
gem 'aws-sdk'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-history'
gem 'sidekiq-statistic'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: false
gem 'redis-namespace'
gem "tilt"
gem 'slim-rails'
gem 'rails-ujs'
gem 'jquery-rails'
gem 'sass-rails'
gem 'autoprefixer-rails'
gem 'font-awesome-rails'
gem 'turbolinks'
gem 'slack-notifier'
gem 'sidekiq-scheduler'
gem 'dry-configurable'
gem 'dotenv-rails'
gem 'ruby_bitbankcc'
gem 'ruby_coincheck_client'
gem 'bitflyer'
gem 'zaif'
gem 'webpacker', github: 'rails/webpacker'
gem 'jbuilder'
gem 'mechanize'
gem 'active_model_serializers'
gem 'jwt'
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'byebug', platform: :mri
gem 'pry-byebug'
gem 'meta-tags'
gem 'selenium-webdriver'
gem 'rack-user_agent'
gem 'faraday'
gem 'twitter'
gem 'rails-settings-cached'
gem 'bootsnap', require: false

group :development, :test do
  gem 'pry-stack_explorer'
  gem 'hirb'
  gem 'awesome_print'
  gem 'test-queue'
  gem 'bullet'
  gem 'faker'
  gem 'html2slim'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rspec-sidekiq'
end

group :development do
  gem "capistrano"
  gem "capistrano-bundler"
  gem "capistrano-rbenv"
  gem 'capistrano3-unicorn'
  gem "capistrano-rails"
  gem "capistrano-slackify", require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano-yarn'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'benchmark-ips'
  gem 'rails_best_practices'
end

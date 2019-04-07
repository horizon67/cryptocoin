# frozen_string_literal: true

source "https://rubygems.org"
ruby '2.6.2'

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "rails"
gem 'mysql2'
gem 'pry-rails', '~> 0.3.6'
gem 'aws-sdk', '~> 3.0.1'
gem 'sidekiq', '~> 4.2.10'
gem 'sidekiq-failures', '~> 1.0.0'
gem 'sidekiq-history', '~> 0.0.9'
gem 'sidekiq-statistic', '~> 1.2.0'
gem 'sidekiq-unique-jobs', '~> 5.0.10'
gem 'sinatra', '~> 2.0.0', require: false
gem 'redis-namespace', '~> 1.5.3'
gem "tilt", '~> 2.0.8'
gem 'slim-rails', '~> 3.1.3'
gem 'rails-ujs', '~> 0.1.0'
gem 'jquery-rails', '~> 4.3.1'
gem 'sass-rails', '~> 5.0.7'
gem 'autoprefixer-rails', '~> 7.1.6'
gem 'font-awesome-rails', '~> 4.7.0.2'
gem 'turbolinks', '~> 5.0.1'
gem 'slack-notifier', '~> 2.3.2'
gem 'sidekiq-scheduler', '~> 2.2.1'
gem 'dry-configurable', '~> 0.7.0'
gem 'dotenv-rails', '~> 2.2.1'
gem 'ruby_bitbankcc', '~> 0.1.3'
gem 'ruby_coincheck_client', '~> 0.3.0'
gem 'bitflyer', '~> 0.2.0'
gem 'zaif', '~> 0.0.2'
gem 'webpacker', github: 'rails/webpacker'
gem 'jbuilder', '~> 2.7.0'
gem 'mechanize', '~> 2.7.5'
gem 'active_model_serializers', '~> 0.10.7'
gem 'jwt', '~> 2.1.0'
gem 'unicorn', '~> 5.4.0'
gem 'byebug', platform: :mri
gem 'pry-byebug'
gem 'meta-tags', '~>2.7.1'
gem 'selenium-webdriver', '~> 3.9.0'
gem 'rack-user_agent', '~> 0.5.2'
gem 'unicorn-worker-killer', '~> 0.4.4'
gem 'faraday', '~> 0.14.0'
gem 'bitmex', '~> 0.1.2'

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
  gem "capistrano", '~> 3.10.0'
  gem "capistrano-bundler", '~> 1.3.0'
  gem "capistrano-rbenv", '~> 2.1.2'
  gem 'capistrano3-unicorn', '~> 0.2.1'
  gem "capistrano-rails", '~> 1.3.0'
  gem "capistrano-slackify", require: false
  gem 'capistrano-sidekiq'
  gem 'capistrano-yarn', '~> 2.0.2'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'benchmark-ips'
  gem 'rails_best_practices'
end

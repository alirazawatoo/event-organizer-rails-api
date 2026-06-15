source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.1.2"

gem "pg", "~> 1.1"

gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

gem "rack-cors"

gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'jsonapi-rspec'

  gem "capistrano", require: false
  gem "capistrano-rails", require: false
  gem 'capistrano-rbenv'
  gem 'capistrano-passenger'
  gem 'sshkit-sudo'
  gem 'ed25519'# Required for cap deploy
  gem 'bcrypt_pbkdf'# Required for cap deploy
end


# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.26-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-alternative_landing", git: "https://github.com/Platoniq/decidim-module-alternative_landing", branch: "release/0.26-stable"
gem "decidim-decidim_awesome", git: "https://github.com/Platoniq/decidim-module-decidim_awesome", branch: "main"
gem "decidim-direct_verifications", "~> 1.1"
gem "decidim-notify", "~> 0.5"
gem "decidim-templates", DECIDIM_VERSION
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: :develop

gem "decidim-multisurveys", path: "./decidim-multisurveys"

gem "bootsnap", "~> 1.7"
gem "health_check"

gem "faraday"
gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "faker", "~> 2.14"
gem "rspec"

gem "image_processing", ">= 1.2"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "rubocop-faker"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web"
  gem "listen", "~> 3.1"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console"

  gem "capistrano", "~> 3.14"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "figaro", "~> 1.2"
  gem "fog-aws" # to remove once images migrated
  gem "sentry-rails"
  gem "sentry-ruby"
  gem "sentry-sidekiq"
  gem "sidekiq", "~> 6.0"
  gem "sidekiq-cron"
end

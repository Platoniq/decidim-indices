# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim.git", branch: "release/0.23-stable" }

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
gem "decidim-decidim_awesome", "~> 0.6.2"
gem "decidim-direct_verifications", "~> 0.22.0"
gem "decidim-notify", "~> 0.3.0"
gem "decidim-term_customizer", { git: "https://github.com/platoniq/decidim-module-term_customizer", branch: "temp/0.23" }

gem "bootsnap", "~> 1.4"
gem "health_check"
gem "sidekiq", "~> 6.0"
gem "sidekiq-cron"
gem "sentry-rails"
gem "sentry-ruby"

gem "puma", ">= 4.3.5"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"
gem "rspec"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end

group :production do
  gem "fog-aws"
end

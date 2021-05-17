# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim.git", branch: "release/0.24-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-conferences", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-decidim_awesome", "~> 0.7.0"
gem "decidim-decidim_awesome", git: "https://github.com/Platoniq/decidim-module-decidim_awesome", branch: "custom-fields"
gem "decidim-direct_verifications", git: "https://github.com/Platoniq/decidim-verifications-direct_verifications", branch: "devel"
gem "decidim-notify", "~> 0.4.0"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer"

gem "bootsnap", "~> 1.4"
gem "health_check"
gem "sentry-rails"
gem "sentry-ruby"
gem "sidekiq", "~> 6.0"
gem "sidekiq-cron"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"
gem "faraday"

gem "faker", "~> 2.14"
gem "rspec"
gem "rubocop-faker"

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

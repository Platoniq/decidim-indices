# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECDIDIM_VERSION = { git: "https://github.com/Platoniq/decidim", branch: "0.21-stable" }
gem "decidim", DECDIDIM_VERSION
gem "decidim-consultations", DECDIDIM_VERSION
gem "decidim-conferences", DECDIDIM_VERSION
# gem "decidim-initiatives", DECDIDIM_VERSION
gem "decidim-decidim_awesome", git: "https://github.com/Platoniq/decidim-module-decidim_awesome"
gem "decidim-direct_verifications", git: "https://github.com/Platoniq/decidim-verifications-direct_verifications"
gem "decidim-notify", git: "https://github.com/Platoniq/decidim-module-notify"

gem "bootsnap", "~> 1.4"
gem "health_check"
gem "sidekiq", "~> 6.0"
gem "sidekiq-cron"
gem "sentry-raven"

gem "puma", "~> 4.3"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.9"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECDIDIM_VERSION
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

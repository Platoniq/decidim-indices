Decidim::Notify.configure do |config|
  config.cable_adapter = "redis"
  config.cable_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }
end

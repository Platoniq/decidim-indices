require 'rake'

Rails.application.load_tasks

class MetricsGenerationWorker
  include Sidekiq::Worker

  def perform(*args)
		Rake::Task["decidim:metrics:all"].invoke
  end
end

# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class MembersAsFollowersWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["indices:members_as_followers"].invoke
  end
end

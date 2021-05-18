# frozen_string_literal: true

require "indices/weblyzard_service"
require "indices/proposal_parser"

# configure Weblyzard service
Indices::WeblyzardService.configure do |config|
  config.username = Rails.application.secrets.weblyzard[:username]
  config.password = Rails.application.secrets.weblyzard[:password]
end

# Subscribe to event and publicate results
Decidim::EventsManager.subscribe(/^decidim\.events\./) do |event_name, data|
  parser = case event_name
           when "decidim.events.proposals.proposal_published"
             Indices::ProposalParser.new(data[:resource])
           end

  if parser
    unless parser.valid?
      Rails.logger.error "Not publishing event ##{data[:resource].id} [#{event_name}] to Weblyzard API: #{parser.errors.values}"
      break
    end

    result = Indices::WeblyzardService.publish(parser)
    if result
      Rails.logger.info "Published event ##{data[:resource].id} [#{event_name}] to Weblyzard API with UID #{result["_id"]}"
    else
      Rails.logger.error "Error publishing event ##{data[:resource].id} [#{event_name}] to Weblyzard API #{result}"
    end
  end
end

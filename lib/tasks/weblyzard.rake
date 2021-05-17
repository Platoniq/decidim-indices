# frozen_string_literal: true

# lib/tasks/weblyzard.rake

require "indices/proposal_parser"

namespace :indices do
  namespace :weblyzard do
    desc "Ensures locales in organizations are in sync with Decidim configuration"
    task publish_all: :environment do
      # TODO: configurable
      organization = Decidim::Organization.first

      puts "Working on organization [#{organization.name}]"

      organization.public_participatory_spaces.each do |space|
        # TODO: send participatory space text?
        unless defined? space.components
          puts "Skipping participatory space [#{space.manifest.name}-#{space.id}] without components"
          next
        end

        puts "Found participatory space [#{space.manifest.name}-#{space.id}] with #{space&.components&.count} components"

        space.components.each do |component|
          puts "Processing on component  #{component.manifest_name} [#{component.name.first[1]}]"

          publish_proposals_for component
        end
      end
    end

    def publish_proposals_for(component)
      Decidim::Proposals::Proposal.published.except_withdrawn.except_rejected.where(component: component).find_each do |proposal|
        puts "Found proposal ##{proposal.id} [#{proposal.title}]"

        publish Indices::ProposalParser.new(proposal)
      end
    end

    def publish(parser)
      unless parser.valid?
        puts "Not publishing resource #{parser.uri} to Weblyzard API: #{parser.errors.values}"
        Rails.logger.error "Not publishing resource #{parser.uri} to Weblyzard API: #{parser.errors.values}"
        return
      end

      res = Indices::WeblyzardService.publish(parser)
      if res
        attributes = JSON.parse(res.body)
        puts "Published resource #{parser.uri} to Weblyzard API with ID #{attributes["_id"]}"
        Rails.logger.info "Published resource #{parser.uri} to Weblyzard API with ID #{attributes["_id"]}"
      else
        puts "ERROR publishing proposal #{parser.uri}] to Weblyzard API #{attributes}"
        Rails.logger.error "ERROR publishing proposal #{parser.uri}] to Weblyzard API"
      end
    end
  end
end

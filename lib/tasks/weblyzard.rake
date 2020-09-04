# lib/tasks/weblyzard.rake

require "indices/proposal_parser"

namespace :indices do
  desc "Ensures locales in organizations are in sync with Decidim configuration"
  task weblyzard: :environment do
    # TODO: configurable
    organization = Decidim::Organization.first
    
    # puts "Working on organization [#{organization.name}]"
    
    # organization.public_participatory_spaces.each do |space|
    #   # TODO: send participatory space text?
    #   unless defined? space.components
    #     puts "Skipping participatory space [#{space.manifest.name}-#{space.id}] without components"
    #     next
    #   end

    #   puts "Found participatory space [#{space.manifest.name}-#{space.id}] with #{space&.components&.count} components"

    #   space.components.each do |component|
    #     puts "  #{component.manifest_name} [#{component.name.first[1]}]"
    #   end
    # end

    Decidim::Proposals::Proposal.all.each do |proposal|
      next if proposal.organization != organization
      # puts "Found proposal ##{proposal.id} [#{proposal.title}]"

      puts Indices::ProposalParser.new(proposal).json
      exit
    end
  end
end
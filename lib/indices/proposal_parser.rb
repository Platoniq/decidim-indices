# frozen_string_literal: true

require "indices/base_parser"

module Indices
  class ProposalParser < BaseParser
    def initialize(proposal)
      @proposal = Decidim::Proposals::ProposalPresenter.new(proposal)
      participatory_space = proposal.participatory_space
      component = proposal.component

      @title = @proposal.title
      @uri = Decidim::ResourceLocatorPresenter.new(proposal).url
      @content_type = "text/html"
      @content = simple_format(@proposal.body(links: true))
      @date = proposal.published_at
      @locale = proposal.organization.default_locale
      @user_name = @proposal.author.name
      @category = participatory_space.title[@locale]
      @container = Decidim::EngineRouter.main_proxy(component).root_url
    end
  end
end

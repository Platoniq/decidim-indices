# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SurveySectionsGroup
    # This is the engine that runs on the public interface of survey_sections_group.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SurveySectionsGroup

      routes do
        # Add engine routes here
        # resources :survey_sections_group
        # root to: "survey_sections_group#index"
        resources :survey_sections_group, only: [:show], controller: :application
        root to: "application#show"
      end

      config.to_prepare do
        Decidim::Component.include(Decidim::SurveySectionsGroup::ComponentOverride)
      end

      initializer "SurveySectionsGroup.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end

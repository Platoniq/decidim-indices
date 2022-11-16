# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module SurveySections
    # This is the engine that runs on the public interface of survey_sections.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::SurveySections

      routes do
        # Add engine routes here
        # resources :survey_sections
        resources :survey_sections, only: [:show], controller: :application
        root to: "application#show"
      end

      initializer "SurveySections.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end

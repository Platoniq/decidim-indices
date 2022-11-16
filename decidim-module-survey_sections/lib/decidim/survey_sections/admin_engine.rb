# frozen_string_literal: true

module Decidim
  module SurveySections
    # This is the engine that runs on the public interface of `SurveySections`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SurveySections::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        get "/survey_sections/:id", to: "survey_sections#show", as: :survey_section_show
        delete "/survey_sections/:id", to: "survey_sections#destroy", as: :survey_section_destroy
        post "/", to: "survey_sections#update", as: :survey_section
        root to: "survey_sections#edit"
      end

      def load_seed
        nil
      end
    end
  end
end

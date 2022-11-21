# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    # This is the engine that runs on the public interface of `SurveySectionsGroup`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SurveySectionsGroup::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :survey_sections_group do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "survey_sections_group#index"
        get "/survey_sections_group/:id", to: "survey_sections_group#show", as: :survey_sections_group_show
        delete "/survey_sections_group/:id", to: "survey_sections_group#destroy", as: :survey_section_destroy
        post "/", to: "survey_sections_group#update", as: :survey_sections_group
        root to: "survey_sections_group#edit"

      end

      def load_seed
        nil
      end
    end
  end
end

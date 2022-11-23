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

        post "/", to: "survey_sections_group#update", as: :survey_sections_group
        get "/survey_sections/:id/edit", to: "survey_sections#edit", as: :admin_edit_survey_sections
        post "/survey_sections/:id/edit", to: "survey_sections#update", as: :admin_update_survey_sections
        delete "/survey_sections/:id", to: "survey_sections#destroy", as: :admin_destroy_survey_sections
        root to: "survey_sections_group#edit"
      end

      def load_seed
        nil
      end
    end
  end
end

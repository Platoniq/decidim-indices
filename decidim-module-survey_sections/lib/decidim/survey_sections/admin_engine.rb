# frozen_string_literal: true

module Decidim
  module SurveySections
    # This is the engine that runs on the public interface of `SurveySections`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::SurveySections::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :survey_sections do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "survey_sections#index"
      end

      def load_seed
        nil
      end
    end
  end
end

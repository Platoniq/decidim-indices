# frozen_string_literal: true

module Decidim
  module Multisurveys
    # This is the engine that runs on the public interface of `Multisurvey`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Multisurveys::Admin

      paths["lib/tasks"] = nil

      routes do
        root to: "multisurveys#show"
      end

      def load_seed
        nil
      end
    end
  end
end

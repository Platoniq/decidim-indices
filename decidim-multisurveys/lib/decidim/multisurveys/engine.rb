# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Multisurveys
    # This is the engine that runs on the public interface of multisurvey.
    # Handles all the logic related to delegation except verifications
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Multisurveys

      routes do
        root to: "multisurveys#show"
      end
    end
  end
end

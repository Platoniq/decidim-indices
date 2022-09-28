# frozen_string_literal: true

module Decidim
  module Multisurveys
    # The data store for a Multisurvey in the Decidim::Multisurveys component.
    class Multisurvey < Multisurveys::ApplicationRecord
      include Decidim::HasComponent

      component_manifest_name "multisurveys"
    end
  end
end

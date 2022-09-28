# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Multisurvey
    # A concern with the components needed when you want a model to be have many questionnaires attached
    module HasQuestionnaires
      extend ActiveSupport::Concern

      included do
        has_many :questionnaires,
                 class_name: "Decidim::Forms::Questionnaire",
                 dependent: :destroy,
                 inverse_of: :questionnaire_for,
                 as: :questionnaire_for
      end
    end
  end
end

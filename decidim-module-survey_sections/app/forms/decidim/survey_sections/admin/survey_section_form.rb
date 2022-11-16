# frozen_string_literal: true

module Decidim
  module SurveySections
    module Admin
      # This class holds a Form to update pages from Decidim's admin panel.
      class
      SurveySectionForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :weight, Integer

        validates :title, translatable_presence: true
        validates :weight, presence: true
        def to_param
          return id if id.present?

          "survey_sections-survey_section-id"
          # "questionnaire-question-id"
        end
      end
    end
  end
end

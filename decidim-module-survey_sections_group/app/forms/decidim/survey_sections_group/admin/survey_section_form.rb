# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      # This class holds a Form to update pages from Decidim's admin panel.
      class
      SurveySectionForm < Decidim::Form
        include TranslatableAttributes
        include Decidim::ApplicationHelper

        translatable_attribute :title, String
        translatable_attribute :description, String
        attribute :weight, Integer
        attribute :surveys, Array[Component]

        validates :title, translatable_presence: true
        validates :weight, presence: true

        def to_param
          return id if id.present?

          "survey_sections_group-survey_section-id"
          # "questionnaire-question-id"
        end

        def surveys_list
          current_participatory_space.components.where(manifest_name: "surveys")
        end
      end
    end
  end
end

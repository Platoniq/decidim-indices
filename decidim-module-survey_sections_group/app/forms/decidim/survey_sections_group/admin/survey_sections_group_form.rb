# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      # This class holds a Form to update pages from Decidim's admin panel.
      class
      SurveySectionsGroupForm < Decidim::Form
        include TranslatableAttributes

        translatable_attribute :name, String
        attribute :survey_sections, Array[SurveySectionForm]

        validates :name, presence: true

        def map_model(model)
          self.survey_sections = model.survey_sections.map do |survey_section|
            SurveySectionForm.from_model(survey_section)
          end
        end
      end
    end
  end
end

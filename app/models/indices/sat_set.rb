# frozen_string_literal: true

module Indices
  # The data store for the self assessment tool set
  class SatSet < ApplicationRecord
    include Decidim::TranslatableAttributes

    self.table_name = "indices_sat_set"

    belongs_to :organization,
               class_name: "Decidim::Organization"

    belongs_to :questionnaire,
               class_name: "Decidim::Forms::Questionnaire"

    validates :name, presence: true

    def survey_name
      return @survey_name if @survey_name

      component = questionnaire.questionnaire_for.component
      @survey_name = "#{translated_attribute(component.participatory_space.title)} :: #{translated_attribute(component.name)}"
    end
  end
end

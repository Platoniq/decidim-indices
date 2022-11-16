# frozen_string_literal: true

module Decidim
  module SurveySections
    class SurveySection < SurveySections::ApplicationRecord
      include Decidim::TranslatableResource
      include Decidim::WeightSortable
      WEIGHT_SCOPE = :decidim_survey_section_component_id
      translatable_fields :title, :description

      self.table_name = "decidim_survey_sections"
      validates :title, :description, presence: true
      validates :weight, presence: true

      has_many :decidim_survey_groups,
               class_name: "Decidim::SurveyGroup",
               foreign_key: "decidim_survey_section_id", dependent: :destroy

      has_many :surveys, through: :decidim_survey_groups,
                         foreign_key: "survey_id"
      belongs_to :survey_section_component, class_name: "Decidim::Component",
                                            foreign_key: "decidim_survey_section_component_id"

      def ordered_surveys
        decidim_survey_groups.map(&:survey)
      end
    end
  end
end

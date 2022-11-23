# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    class SurveySection < ApplicationRecord
      include Decidim::TranslatableResource
      include Decidim::SurveySectionsGroup::WeightSortable
      WEIGHT_SCOPE = :decidim_survey_sections_group_id
      translatable_fields :title, :description

      self.table_name = "decidim_survey_sections"
      validates :title, :description, presence: true
      validates :weight, presence: true

      has_many :decidim_survey_groups,
               class_name: "Decidim::SurveySectionsGroup::SurveyGroup",
               foreign_key: "decidim_survey_section_id", dependent: :destroy

      has_many :surveys, through: :decidim_survey_groups,
                         foreign_key: "survey_id"
      belongs_to :survey_sections_group, class_name: "Decidim::Component",
                                         foreign_key: "decidim_survey_sections_group_id"

      def ordered_surveys
        decidim_survey_groups.map(&:survey)
      end
    end
  end
end

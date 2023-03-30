# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    class SurveyGroup < ApplicationRecord
      include Decidim::SurveySectionsGroup::WeightSortable
      WEIGHT_SCOPE = :decidim_survey_section_id
      self.table_name = "decidim_survey_groups"
      belongs_to :survey_section, class_name: "Decidim::SurveySectionsGroup::SurveySection", foreign_key: "decidim_survey_section_id"
      belongs_to :survey, class_name: "Decidim::Component"

      def previous_survey_for(user)
        self.class.where(decidim_survey_section_id: survey_section.id)
            .joins(:survey)
            .where("decidim_components.weight < ?", survey.weight)
            .sort_by { |s| s.survey.weight }
            .reverse
            .find { |s| !s.survey.answered_by?(user.id) }
      end

      def next_survey_for(user)
        self.class.where(decidim_survey_section_id: survey_section.id)
            .joins(:survey)
            .where("decidim_components.weight > ?", survey.weight)
            .sort_by { |s| s.survey.weight }
            .find { |s| !s.survey.answered_by?(user.id) }
      end
    end
  end
end

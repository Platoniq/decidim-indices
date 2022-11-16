# frozen_string_literal: true

module Decidim
  class SurveyGroup < ApplicationRecord
    include Decidim::WeightSortable
    WEIGHT_SCOPE = :decidim_survey_section_id
    self.table_name = "decidim_survey_groups"
    belongs_to :survey_section, class_name: "Decidim::SurveySections::SurveySection", foreign_key: "decidim_survey_section_id"
    belongs_to :survey, class_name: "Decidim::Component"

    def previous_survey_for(user)
      self.class.where("weight < ? AND decidim_survey_section_id = ?", weight, survey_section.id)&.find { |s| s.survey.answered_by?(user.id) == false }
    end

    def next_survey_for(user)
      self.class.where("weight > ? AND decidim_survey_section_id = ?", weight, survey_section.id)&.find { |s| s.survey.answered_by?(user.id) == false }
    end
  end
end

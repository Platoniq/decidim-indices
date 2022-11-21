# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module ComponentOverride
      extend ActiveSupport::Concern

      included do
        has_many :survey_groups,
                 class_name: "Decidim::SurveySectionsGroup::SurveyGroup",
                 foreign_key: ":survey_id", dependent: :destroy

        has_many :survey_sections,
                 class_name: "Decidim::SurveySectionsGroup::SurveySection",
                 foreign_key: "decidim_survey_sections_group_id", dependent: :destroy


        def answered_by?(user)
          Decidim::Surveys::Survey.find_by(decidim_component_id: id)&.answered_by?(user)
        end
      end
    end
  end
end

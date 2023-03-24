# frozen_string_literal: true

module Decidim
  module Overrides
    module Surveys
      module SurveysController
        def show
          return super unless visitor_already_answered? && sat_set

          redirect_to feedback_survey_path(survey, anchor: "key-recommendations")
        end

        def feedback
          return head 404 unless current_user

          survey = Decidim::SurveySectionsGroup::SurveyGroup.find_by(survey_id: params[:component_id])
          if survey
            @side_surveys = { previous_survey: survey.previous_survey_for(current_user), next_survey: survey.next_survey_for(current_user) }
            @survey_sections_group = survey.survey_section.survey_sections_group
          end
        end

        def self.prepended(base)
          base.class_eval do
            base.helper_method :survey, :sat_set, :key_recommendations, :other_recommendations, :sat_lite
          end
        end

        protected

        def sat_set
          @sat_set ||= Indices::SatSet.find_by(questionnaire: questionnaire)
        end

        def sat_lite
          @sat_lite ||= Indices::SatLite.find_by(questionnaire: questionnaire)
        end

        def key_recommendations
          return unless sat_set.results(current_user)

          @key_recommendations ||= sat_set.results(current_user).select { |r| r.score.positive? }.slice(0, 2)
        end

        def other_recommendations
          @other_recommendations ||= sat_set.results(current_user) - key_recommendations
        end
      end
    end
  end
end

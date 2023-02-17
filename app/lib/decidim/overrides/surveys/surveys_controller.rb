# frozen_string_literal: true

module Decidim
  module Overrides
    module Surveys
      module SurveysController
        def show
          return super unless visitor_already_answered? && sat_set

          redirect_to feedback_survey_path(survey, anchor: "key-recommendations")
        end

        def self.prepended(base)
          base.class_eval do
            base.helper_method :survey, :sat_set, :key_recommendations, :other_recommendations
          end
        end

        protected

        def sat_set
          @sat_set ||= Indices::SatSet.find_by(questionnaire: questionnaire)
        end

        def key_recommendations
          return unless sat_set.results

          @key_recommendations ||= sat_set.results.select { |r| r.score.positive? }
        end

        def other_recommendations
          @other_recommendations ||= sat_set.results - key_recommendations
        end
      end
    end
  end
end

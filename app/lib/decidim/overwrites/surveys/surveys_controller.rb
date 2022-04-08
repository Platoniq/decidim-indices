# frozen_string_literal: true

module Decidim
  module Overwrites
    module Surveys
      module SurveysController
        def show
          return super unless visitor_already_answered? && sat_set

          redirect_to feedback_survey_path(survey, anchor: "key-recommendations")
        end

        def feedback
          render template: "questionnaire_closed.html" unless allow_answers?
        end

        def self.prepended(base)
          base.class_eval do
            base.helper_method :survey, :sat_set, :columns, :link_class
          end
        end

        protected

        def sat_set
          @sat_set ||= Indices::SatSet.find_by(questionnaire: questionnaire)
        end

        def columns
          @columns ||= allow_answers? && visitor_can_answer? ? 9 : 6
        end

        def link_class(active, current)
          string = "button small card__button"
          "#{string} hollow" if active != current
          string
        end
      end
    end
  end
end

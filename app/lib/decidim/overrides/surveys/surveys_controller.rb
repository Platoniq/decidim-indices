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
          survey = Decidim::SurveyGroup.find_by(survey_id: params[:component_id])
          @side_surveys = { previous_survey: survey.previous_survey_for(current_user), next_survey: survey.next_survey_for(current_user) }
          render template: "questionnaire_closed.html" unless allow_answers?
        end

        def export_user_answers
          # enforce_permission_to :export_response, :questionnaire_answers

          answers = Decidim::Forms::QuestionnaireUserAnswers.for(questionnaire)

          user_answers = answers.select { |a| a.first.decidim_user_id == current_user.id }

          title = t("export_response.title", scope: "decidim.forms.admin.questionnaires.answers", token: user_answers.first.first.session_token)

          Decidim::Forms::ExportQuestionnaireAnswersCSVJob.perform_later(current_user, title, user_answers)

          flash[:notice] = t("decidim.admin.exports.notice")

          redirect_to feedback_survey_path(survey)
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

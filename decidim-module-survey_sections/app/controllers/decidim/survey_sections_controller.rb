# frozen_string_literal: true

module Decidim
  class SurveySectionsController < Decidim::ApplicationController
    before_action :set_default_request_format

    def export_user_answers
      answers = Decidim::Forms::QuestionnaireUserAnswers.for(Decidim::Surveys::Survey.find_by(decidim_component_id: params[:id]).questionnaire)

      user_answers = answers.select { |a| a.first.decidim_user_id == current_user.id }

      title = t("export_response.title", scope: "decidim.forms.admin.questionnaires.answers", token: user_answers.first.first.session_token)

      Decidim::Forms::ExportQuestionnaireAnswersCSVJob.perform_later(current_user, title, user_answers)

      flash[:notice] = t("decidim.admin.exports.notice")

      redirect_to Decidim::EngineRouter.main_proxy(Decidim::Component.find_by(id: params[:component_id])).root_path
    end

    private

    def set_default_request_format
      request.format = :html
    end
  end
end

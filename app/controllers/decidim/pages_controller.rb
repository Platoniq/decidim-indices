# frozen_string_literal: true

module Decidim
  # This controller serves static pages using HighVoltage.
  class PagesController < Decidim::ApplicationController
    layout "layouts/decidim/application"

    helper_method :page, :pages
    helper CtaButtonHelper
    helper Decidim::ResourceHelper
    helper Decidim::SanitizeHelper

    before_action :set_default_request_format

    def index
      enforce_permission_to :read, :public_page
      @topics = StaticPageTopic.where(organization: current_organization)
      @orphan_pages = StaticPage.where(topic: nil, organization: current_organization)
    end

    def show
      @page = current_organization.static_pages.find_by!(slug: params[:id])
      enforce_permission_to :read, :public_page, page: @page
      @topic = @page.topic
      @pages = @topic&.pages
    end

    def export_user_answers
      answers = Decidim::Forms::QuestionnaireUserAnswers.for(Decidim::Surveys::Survey.find_by(decidim_component_id: params[:id]).questionnaire)

      user_answers = answers.select { |a| a.first.decidim_user_id == current_user.id }

      title = t("export_response.title", scope: "decidim.forms.admin.questionnaires.answers", token: user_answers.first.first.session_token)

      Decidim::Forms::ExportQuestionnaireAnswersCSVJob.perform_later(current_user, title, user_answers)

      flash[:notice] = t("decidim.admin.exports.notice")

      redirect_to helpers.resource_locator(Decidim::Pages::Page.find_by(decidim_component_id: params[:component_id])).path
    end

    private

    def set_default_request_format
      request.format = :html
    end
  end
end

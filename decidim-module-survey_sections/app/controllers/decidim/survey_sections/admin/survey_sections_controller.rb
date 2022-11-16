# frozen_string_literal: true

module Decidim
  module SurveySections
    module Admin
      class SurveySectionsController < Admin::ApplicationController
        helper_method :blank_survey_section

        def show
          @survey_section = Decidim::SurveySections::SurveySection.find(params[:id])
        end

        def edit
          enforce_permission_to :update, :survey_section

          @form = form(Admin::SurveySectionsForm).from_model(survey_section)
        end

        def update
          enforce_permission_to :update, :survey_section

          @form = form(Admin::SurveySectionsForm).from_params(params)

          Admin::UpdateSurveySection.call(@form, survey_section) do
            on(:ok) do
              flash[:notice] = I18n.t("survey_sections.update.success", scope: "decidim.survey_sections.admin")
              redirect_to parent_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_sections.update.invalid", scope: "decidim.survey_sections.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          @survey_section = Decidim::SurveySections::SurveySection.find(params[:id])
          if @survey_section.destroy
            flash[:notice] = I18n.t("survey_sections.destroy.success", scope: "decidim.survey_sections.admin")
            redirect_to parent_path
          else
            flash[:notice] = I18n.t("survey_sections.destroy.invalid", scope: "decidim.survey_sections.admin")
            render action: "edit"
          end
        end

        def blank_survey_section
          @blank_survey_section ||= Admin::SurveySectionForm.new
        end

        private

        def survey_section
          @survey_section_component = current_component
        end
      end
    end
  end
end

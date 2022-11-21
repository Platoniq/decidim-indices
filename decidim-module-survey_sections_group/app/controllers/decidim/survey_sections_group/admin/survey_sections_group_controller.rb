# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      class SurveySectionsGroupController < Admin::ApplicationController
        helper_method :blank_survey_section

        def show
          @survey_section = Decidim::SurveySectionsGroup::SurveySection.find(params[:id])
        end

        def edit
          enforce_permission_to :update, :survey_sections_group

          @form = form(Admin::SurveySectionsGroupForm).from_model(survey_sections_group)
        end

        def update
          enforce_permission_to :update, :survey_sections_group

          @form = form(Admin::SurveySectionsGroupForm).from_params(params)

          Admin::UpdateSurveySectionsGroup.call(@form, survey_sections_group) do
            on(:ok) do
              flash[:notice] = I18n.t("survey_sections_group.update.success", scope: "decidim.survey_sections_group.admin")
              redirect_to parent_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_sections_group.update.invalid", scope: "decidim.survey_sections_group.admin")
              render action: "edit"
            end
          end
        end

        def destroy
          @survey_section = Decidim::SurveySectionsGroup::SurveySection.find(params[:id])
          if @survey_section.destroy
            flash[:notice] = I18n.t("survey_sections_group.destroy.success", scope: "decidim.survey_sections_group.admin")
            redirect_to parent_path
          else
            flash[:notice] = I18n.t("survey_sections_group.destroy.invalid", scope: "decidim.survey_sections_group.admin")
            render action: "edit"
          end
        end

        def blank_survey_section
          @blank_survey_section ||= Admin::SurveySectionForm.new
        end

        private

        def survey_sections_group
          @survey_section_group = current_component
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      class SurveySectionsController < Admin::ApplicationController
        def edit
          enforce_permission_to :update, :survey_sections_group
          @survey_section = Decidim::SurveySectionsGroup::SurveySection.find(params[:id])
          @form = form(Admin::SurveySectionForm).from_model(@survey_section)
        end

        def update
          enforce_permission_to :update, :survey_sections
          survey_section = Decidim::SurveySectionsGroup::SurveySection.find(params[:id])
          @form = form(Admin::SurveySectionForm).from_params(params)

          Admin::UpdateSurveySections.call(@form, survey_section) do
            on(:ok) do
              flash[:notice] = I18n.t("survey_sections.update.success", scope: "decidim.survey_sections_group.admin")
              redirect_to survey_sections_group_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("survey_sections.update.invalid", scope: "decidim.survey_sections_group.admin")
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
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      # This command is executed when the user changes a SurveySection from the admin
      # panel.
      class UpdateSurveySections < Rectify::Command
        # Initializes a UpdatePage Command.
        #
        # form - The form from which to get the data.
        # page - The current instance of the survey_section to be updated.
        def initialize(form, survey_sections)
          @form = form
          @survey_sections = survey_sections
        end

        # Updates the survey_section if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if @form.invalid?

          update_survey_sections

          broadcast(:ok)
        end

        private

        def update_survey_sections
          Decidim.traceability.update!(
            @survey_sections,
            @form.current_user,
            title: @form.title,
            description: @form.description,
            weight: @form.weight,
            surveys: Decidim::Component.find(@form.surveys.reject(&:empty?))
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SurveySectionsGroup
    module Admin
      # This command is executed when the user changes a SurveySection from the admin
      # panel.
      class UpdateSurveySectionsGroup < Rectify::Command
        # Initializes a UpdatePage Command.
        #
        # form - The form from which to get the data.
        # page - The current instance of the survey_section to be updated.
        def initialize(form, survey_sections_group)
          @form = form
          @survey_sections_group = survey_sections_group
        end

        # Updates the survey_section if valid.
        #
        # Broadcasts :ok if successful, :invalid otherwise.
        def call
          return broadcast(:invalid) if @form.invalid?

          update_survey_sections_group_survey_sections if @survey_sections_group
          update_survey_sections_group

          broadcast(:ok)
        end

        private

        def update_survey_sections_group_survey_sections
          @form.survey_sections.each do |form_survey_section|
            update_survey_sections_group_survey_section(form_survey_section)
          end
        end

        def update_survey_sections_group_survey_section(form_survey_section)
          survey_section_attributes = {
            title: form_survey_section.title,
            description: form_survey_section.description,
            weight: form_survey_section.weight
          }
          update_nested_model(form_survey_section, survey_section_attributes, @survey_sections_group.survey_sections)
        end

        def update_nested_model(form, attributes, parent_association)
          record = parent_association.find_by(id: form.id) || parent_association.build(attributes)

          yield record if block_given?

          if record.persisted?
            if form.deleted?
              record.destroy!
            else
              record.update!(attributes)
            end
          else
            record.save!
          end
        end

        def update_survey_sections_group
          Decidim.traceability.update!(
            @survey_sections_group,
            @form.current_user,
            name: @form.name
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module SurveySections
    module Admin
      module ApplicationHelper
        def tabs_id_for_survey_section(survey_section)
          "survey_sections_survey_section_#{survey_section.to_param}"
          # "questionnaire_question#{survey_section.to_param}"
        end

        def dynamic_title(title, **options)
          data = {
            "max-length" => options[:max_length],
            "omission" => options[:omission],
            "placeholder" => options[:placeholder],
            "locale" => I18n.locale
          }
          tag.span(class: options[:class], data: data) do
            truncate translated_attribute(title), length: options[:max_length], omission: options[:omission]
          end
        end
      end
    end
  end
end

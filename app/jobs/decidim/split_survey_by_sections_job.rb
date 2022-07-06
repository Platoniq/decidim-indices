# frozen_string_literal: true

module Decidim
  class SplitSurveyBySectionsJob < ApplicationJob
    queue_as :default

    # CSV file must have a column with the section_id and a column with the question_id
    def perform(component_id, csv_file, admin_email)
      @component_id = component_id
      @csv_file = csv_file
      @admin_email = admin_email

      data = CSV.parse(File.read(@csv_file), headers: true)

      sections = data.map { |d| d["section_id"] }.compact.uniq

      questions_for_section = {}

      data.each do |d|
        section_id = d["section_id"]
        next unless section_id.present?
        
        question_id = d["question_id"]
        questions_for_section[section_id] ||= []
        questions_for_section[section_id] << question_id
      end

      sections.each do |section|
        title = map_locales("Survey for section #{section}")
        description = title

        params = {
          name: title,
          manifest_name: :surveys,
          participatory_space: original_survey.component.participatory_space,
          settings: {
            allow_answers: true
          },
          published_at: Time.now
        }

        questionnaires = []
        surveys = []
        components = []
        questions = []
        answers = []

        Decidim::Forms::Answer.transaction do
          Decidim::Forms::Question.transaction do
            Decidim::Forms::Questionnaire.transaction do
              Decidim::Component.transaction do
                component = Decidim.traceability.perform_action!(
                  "publish",
                  Decidim::Component,
                  admin_user,
                  visibility: "all"
                ) do
                  Decidim::Component.create!(params)
                end

                questionnaire = Decidim::Forms::Questionnaire.new(
                  title: map_locales("Section title #{section}"),
                  description: description,
                  tos: original_questionnaire.tos
                )

                survey = Decidim.traceability.create!(
                  Decidim::Surveys::Survey,
                  admin_user,
                  {
                    questionnaire: questionnaire,
                    component: component
                  },
                  visibility: "all"
                )

                questionnaire.save!

                questions_for_section[section].each do |question_id|
                  question = Decidim::Forms::Question.find(question_id)
                  question.update!(questionnaire: survey.questionnaire)
                  question_answers = Decidim::Forms::Answer.where(question: question)
                  question_answers.update_all(decidim_questionnaire_id: questionnaire.id)

                  questions << question
                  answers = answers + question_answers

                  Decidim::Forms::DisplayCondition.where(question: questions).destroy_all
                end

                components << component
                questionnaires << questionnaire
                surveys << survey
              end
            end
          end
        end

        Rails.logger.info "Created questionnaires #{questionnaires}"
        Rails.logger.info "Created surveys #{surveys}"
        Rails.logger.info "Created components #{components}"
        Rails.logger.info "Updated questions #{questions}"
        Rails.logger.info "Updated answers #{answers}"
      end
    end

    private

    def original_survey
      @original_survey ||= Decidim::Surveys::Survey.find_by(decidim_component_id: @component_id)
    end

    def original_questionnaire
      @questionnaire ||= original_survey.questionnaire
    end
    
    def organization
      @organization ||= original_survey.organization
    end
    
    def map_locales(string)
      organization.available_locales.map do |locale|
        [locale, string]
      end.to_h
    end

    def admin_user
      Decidim::User.where(organization: organization, email: @admin_email)
    end
  end
end

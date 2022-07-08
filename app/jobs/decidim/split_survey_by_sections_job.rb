# frozen_string_literal: true

# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity

module Decidim
  # Usage: Decidim::SplitSurveyBySectionsJob.perform_now(131, "sections_and_questions.csv", "admin@example.com")
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
        next if section_id.blank?

        question_id = d["question_id"]
        questions_for_section[section_id] ||= []
        questions_for_section[section_id] << question_id
      end

      questionnaires = []
      surveys = []
      components = []
      questions = []
      answers = []

      sections.each do |section|
        title = map_locales("Survey for section #{section}")
        description = title

        participatory_space = original_survey.component.participatory_space

        params = {
          name: title,
          manifest_name: :surveys,
          participatory_space: participatory_space,
          settings: {
            allow_answers: true
          },
          step_settings: { participatory_space.active_step.id => { allow_answers: true } },
          published_at: Time.zone.now
        }

        # rubocop:disable Rails/SkipsModelValidations
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
                  answers += question_answers

                  Decidim::Forms::DisplayCondition.where(question: questions).destroy_all
                end

                components << component
                questionnaires << questionnaire
                surveys << survey
              end
            end
          end
        end
        # rubocop:enable Rails/SkipsModelValidations
      end

      Rails.logger.info "Created questionnaires #{questionnaires}"
      Rails.logger.info "Created surveys #{surveys}"
      Rails.logger.info "Created components #{components}"
      Rails.logger.info "Updated questions #{questions}"
      Rails.logger.info "Updated answers #{answers}"

      all_new_feedbacks = []

      original_sat_set = Indices::SatSet.find_by(questionnaire: original_questionnaire)

      Indices::SatSet.transaction do
        Indices::SatFeedback.transaction do
          questionnaires.each do |questionnaire|
            new_sat_set = Indices::SatSet.create!(organization: organization, questionnaire: questionnaire, name: "SAT feedback for '#{questionnaire.title["en"]}'")

            answer_options_with_hashtag = Decidim::Forms::AnswerOption.where(question: questionnaire.questions).where("body->>'en' like ?", "%#%")
            all_present_hashtags = answer_options_with_hashtag.pluck(Arel.sql("body->>'en'")).map { |body| body.match(/#(.*)/).captures }.flatten.uniq

            all_present_hashtags.each do |tag|
              feedbacks = original_sat_set.feedbacks.select { |f| f.hashtags.map { |h| h["tag"] }.include?(tag) }
              feedbacks.map do |feedback|
                f = feedback.dup
                f.sat_set = new_sat_set
                f.save!
              end

              all_new_feedbacks << feedbacks
            end
          end
        end

        Rails.logger.info "Copied feedbacks #{all_new_feedbacks}"
      end
    end

    private

    def original_survey
      @original_survey ||= Decidim::Surveys::Survey.find_by(decidim_component_id: @component_id)
    end

    def original_questionnaire
      @original_questionnaire ||= original_survey.questionnaire
    end

    def organization
      @organization ||= original_survey.organization
    end

    def map_locales(string)
      organization.available_locales.index_with do |_locale|
        string
      end
    end

    def admin_user
      Decidim::User.where(organization: organization, email: @admin_email)
    end
  end
end

# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity

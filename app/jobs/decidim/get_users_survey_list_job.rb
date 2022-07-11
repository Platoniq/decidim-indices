# frozen_string_literal: true

module Decidim
  # Decidim::Surveys::Survey.joins(:component).where(id: survey_ids).pluck("decidim_surveys_surveys.id, decidim_components.name->'en'")

  # Usage: Decidim::GetUsersSurveyListJob.perform_now("satEnumerate", "Decidim::ParticipatoryProcess", "answer_option_survey_map.csv")
  class GetUsersSurveyListJob < ApplicationJob
    queue_as :default

    def perform(participatory_space_slug, participatory_space_type, csv_file)
      @participatory_space = participatory_space_type.constantize.find_by(slug: participatory_space_slug)
      @csv_file = csv_file

      @user_survey_list = {}

      rows = CSV.parse(File.read(@csv_file), headers: true)
      rows.each { |d| get_survey_ids(d["answer_option_id"], d["survey_ids"].split("+")) }

      data = map_data(@user_survey_list)

      Rails.logger.info data.to_json
      File.write("user_surveys_#{Time.zone.now.to_i}.json", data.to_json)
    end

    private

    def get_survey_ids(answer_option_id, survey_ids)
      user_ids = Decidim::Forms::Answer.joins(:choices).where(
        decidim_forms_answer_choices: { decidim_answer_option_id: answer_option_id }
      ).pluck("decidim_forms_answers.decidim_user_id")

      user_ids.each do |id|
        @user_survey_list[id] ||= []
        @user_survey_list[id] << survey_ids
      end
    end

    def map_data(data)
      data.map do |user_id, survey_ids|
        {
          user_id: user_id,
          user_email: Decidim::User.where(id: user_id).limit(1).pick(:email),
          missing_surveys: survey_ids.flatten.map { |survey_id| get_url(survey_id) }
        }
      end
    end

    def get_url(survey_id)
      component = Decidim::Surveys::Survey.find(survey_id).component

      { survey_id: survey_id, title: component.name["en"], url: Decidim::EngineRouter.main_proxy(component).root_url }
    end
  end
end

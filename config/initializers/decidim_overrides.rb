# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Surveys::SurveysController.prepend Decidim::Overrides::Surveys::SurveysController
  Decidim::Forms::MatrixReadonlyCell.prepend Decidim::Overrides::Forms::MatrixReadonlyCell
  Decidim::Forms::AnswerReadonlyCell.prepend Decidim::Overrides::Forms::AnswerReadonlyCell
  Decidim::Forms::StepNavigationCell.prepend Decidim::Overrides::Forms::StepNavigationCell
  Decidim::Forms::AnswerQuestionnaire.prepend Decidim::Overrides::Forms::AnswerQuestionnaire
end

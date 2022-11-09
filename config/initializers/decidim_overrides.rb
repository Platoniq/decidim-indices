# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Surveys::SurveysController.prepend Decidim::Overrides::Surveys::SurveysController
  Decidim::Forms::MatrixReadonlyCell.prepend Decidim::Overrides::Forms::MatrixReadonlyCell
  Decidim::Forms::AnswerReadonlyCell.prepend Decidim::Overrides::Forms::AnswerReadonlyCell
  Decidim::Forms::StepNavigationCell.prepend Decidim::Overrides::Forms::StepNavigationCell
  Decidim::Forms::UserAnswersSerializer.prepend Decidim::Overrides::Forms::UserAnswersSerializer
end

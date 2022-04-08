# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Surveys::SurveysController.prepend Decidim::Overwrites::Surveys::SurveysController
  Decidim::Forms::MatrixReadonlyCell.prepend Decidim::Overwrites::Forms::MatrixReadonlyCell
  Decidim::Forms::AnswerReadonlyCell.prepend Decidim::Overwrites::Forms::AnswerReadonlyCell
end

# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Surveys::SurveysController.prepend Decidim::Overwrites::Surveys::SurveysController
end

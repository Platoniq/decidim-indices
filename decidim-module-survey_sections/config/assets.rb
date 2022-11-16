# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  decidim_survey_sections: "#{base_path}/app/packs/entrypoints/decidim_survey_sections.js",
  decidim_survey_sections_admin: "#{base_path}/app/packs/entrypoints/decidim_survey_sections_admin.js"
)
Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/survey_sections/survey_sections")

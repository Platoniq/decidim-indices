# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/survey_sections_group/version"

Gem::Specification.new do |s|
  s.version = Decidim::SurveySectionsGroup.version
  s.authors = [""]
  s.email = [""]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-survey_sections_group"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-survey_sections_group"
  s.summary = "A decidim survey_sections_group module"
  s.description = "This is a group of Survey Sections."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::SurveySectionsGroup.version
end

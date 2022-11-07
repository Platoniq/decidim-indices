# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/survey_sections/version"

Gem::Specification.new do |s|
  s.version = Decidim::SurveySections.version
  s.authors = [""]
  s.email = [""]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-survey_sections"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-survey_sections"
  s.summary = "A decidim survey_sections module"
  s.description = "This is component is a group of surveys."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::SurveySections.version
end

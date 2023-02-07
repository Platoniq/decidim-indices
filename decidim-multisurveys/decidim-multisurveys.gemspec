# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/multisurveys/version"

MIN_DECIDIM_VERSION = Decidim::Multisurveys::MIN_DECIDIM_VERSION
MAX_DECIDIM_VERSION = Decidim::Multisurveys::MAX_DECIDIM_VERSION

Gem::Specification.new do |s|
  s.version = Decidim::Multisurveys::VERSION
  s.authors = ["Vera Rojman"]
  s.email = ["vera@platoniq.net"]
  s.license = "AGPL-3.0"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-multisurveys"
  s.summary = "A decidim multisurveys module"
  s.description = "A new component that allows combining multiple questionnaires into one multisurvey."

  s.files = Dir["{app,config,lib,db}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "package.json", "README.md"]

  s.add_dependency "decidim-admin", [MIN_DECIDIM_VERSION, MAX_DECIDIM_VERSION]
  s.add_dependency "decidim-core", [MIN_DECIDIM_VERSION, MAX_DECIDIM_VERSION]

  s.add_development_dependency "decidim-dev", [MIN_DECIDIM_VERSION, MAX_DECIDIM_VERSION]
end

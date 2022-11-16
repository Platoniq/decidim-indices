# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :survey_sections_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :survey_sections).i18n_name }
    manifest_name { :survey_sections }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end

# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/forms/test/factories"
require "decidim/participatory_processes/test/factories"

FactoryBot.define do
  factory :multisurveys_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :multisurveys).i18n_name }
    manifest_name { :multisurveys }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  factory :survey, class: "Decidim::Multisurveys::Multisurvey" do
    component { build(:multisurveys_component) }
  end
end

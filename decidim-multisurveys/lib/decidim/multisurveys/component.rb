# frozen_string_literal: true

require "decidim/components/namer"

Decidim.register_component(:multisurveys) do |component|
  component.engine = Decidim::Multisurveys::Engine
  component.admin_engine = Decidim::Multisurveys::AdminEngine

  component.seeds do |participatory_space|
    # Create a Iframe component in all participatory spaces
    admin_user = Decidim::User.find_by(
      organization: participatory_space.organization,
      email: "admin@example.org"
    )

    params = {
      name: Decidim::Components::Namer.new(participatory_space.organization.available_locales, :multisurveys).i18n_name,
      manifest_name: :multisurveys,
      published_at: Time.current,
      participatory_space: participatory_space
    }

    component = Decidim.traceability.perform_action!(
      "publish",
      Decidim::Component,
      admin_user,
      visibility: "all"
    ) do
      Decidim::Component.create!(params)
    end
  end
end

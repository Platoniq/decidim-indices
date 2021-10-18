# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Doorkeeper::CredentialsController.class_eval do
    def public_data
      {
        id: current_resource_owner.id,
        officialized: current_resource_owner.officialized? ? "yes" : "no",
        email: current_resource_owner.email,
        name: current_resource_owner.name,
        nickname: current_resource_owner.nickname,
        image: avatar_url
      }
    end
  end
end

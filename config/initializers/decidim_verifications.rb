# frozen_string_literal: true

# We are using the same DirectVerifications engine without the admin part to
# create a custom verification method called "direct_verifications_managers"
Decidim::Verifications.register_workflow(:direct_verifications_consortium) do |workflow|
  workflow.engine = Decidim::DirectVerifications::Verification::Engine
end

# We need to tell the plugin to handle this method in addition to the default "Direct verification". Any registered workflow is valid.
Decidim::DirectVerifications.configure do |config|
  config.manage_workflows = %w(direct_verifications_consortium)
end

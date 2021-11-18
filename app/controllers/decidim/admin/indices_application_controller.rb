# frozen_string_literal: true

module Decidim
  module Admin
    class IndicesApplicationController < Decidim::Admin::ApplicationController
      before_action :logged_and_admin?

      layout "decidim/admin/indices"

      private

      def logged_and_admin?
        return if current_user&.admin?

        redirect_to decidim_admin.root_path
      end
    end
  end
end

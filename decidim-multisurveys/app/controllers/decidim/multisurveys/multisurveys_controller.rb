# frozen_string_literal: true

module Decidim
  module Multisurveys
    class MultisurveysController < Decidim::Components::BaseController
      helper_method :multisurvey

      def index; end

      private

      def settings
        redirect_to EngineRouter.admin_proxy(component.participatory_space).edit_component_path(id: component)
      end

      def component
        Decidim::Component.find(params[:component_id])
      end

      def multisurvey
        Indices::Multisurvey.find_by(component: component)
      end
    end
  end
end

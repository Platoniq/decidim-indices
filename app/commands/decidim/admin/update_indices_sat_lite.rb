# frozen_string_literal: true

module Decidim
  module Admin
    class UpdateIndicesSatLite < Rectify::Command
      include Decidim::AttachmentAttributesMethods
      def initialize(form, sat_lite)
        @form = form
        @sat_lite = sat_lite
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          update_sat_lite
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_lite)
      end

      private

      attr_reader :form, :sat_lite

      def update_sat_lite
        Decidim.traceability.update!(
          @sat_lite,
          @form.current_user,
          attributes
        )
      end

      def attributes
        {
          questionnaire_id: @form.questionnaire_id,
          name: @form.name,
          iframe: @form.iframe
        }.merge(attachment_attributes(:image))
      end
    end
  end
end

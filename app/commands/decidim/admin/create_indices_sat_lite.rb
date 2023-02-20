# frozen_string_literal: true

module Decidim
  module Admin
    class CreateIndicesSatLite < Rectify::Command
      def initialize(form)
        @form = form
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          create_sat_lite!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_lite)
      end

      private

      attr_reader :form, :sat_lite

      def create_sat_lite!
        @sat_lite = Indices::SatLite.create!(
          organization: form.current_organization,
          questionnaire_id: form.questionnaire_id,
          name: form.name,
          image: form.image,
          iframe: form.iframe
        )
      end
    end
  end
end

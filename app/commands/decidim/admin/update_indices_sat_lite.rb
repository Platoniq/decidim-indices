# frozen_string_literal: true

module Decidim
  module Admin
    class UpdateIndicesSatLite < Rectify::Command
      def initialize(form, sat_lite)
        @form = form
        @sat_lite = sat_lite
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          update_sat_lite!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_lite)
      end

      private

      attr_reader :form, :sat_lite

      def update_sat_lite!
        @sat_lite.questionnaire_id = form.questionnaire_id
        @sat_lite.name = form.name
        @sat_lite.image = form.image
        @sat_lite.save!
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Admin
    class UpdateIndicesSatSet < Rectify::Command
      def initialize(form, sat_set)
        @form = form
        @sat_set = sat_set
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          update_sat_set!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_set)
      end

      private

      attr_reader :form, :sat_set

      def update_sat_set!
        @sat_set.questionnaire_id = form.questionnaire_id
        @sat_set.name = form.name
        @sat_set.save!
      end
    end
  end
end

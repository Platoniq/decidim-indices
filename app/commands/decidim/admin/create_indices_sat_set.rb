# frozen_string_literal: true

module Decidim
  module Admin
    class CreateIndicesSatSet < Rectify::Command
      def initialize(form)
        @form = form
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          create_sat_set!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_set)
      end

      private

      attr_reader :form, :sat_set

      def create_sat_set!
        @sat_set = Indices::SatSet.create!(
          organization: form.current_organization,
          questionnaire_id: form.questionnaire_id,
          name: form.name
        )
      end
    end
  end
end

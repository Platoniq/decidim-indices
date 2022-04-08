# frozen_string_literal: true

module Decidim
  module Admin
    class CreateIndicesSatFeedback < Rectify::Command
      def initialize(form, sat_set)
        @form = form
        @sat_set = sat_set
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          create_sat_set!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_feedback)
      end

      private

      attr_reader :form, :sat_set, :sat_feedback

      def create_sat_set!
        @sat_feedback = Indices::SatFeedback.create!(
          sat_set: sat_set,
          title: form.title,
          subtitle: form.subtitle,
          description: form.description,
          effort: form.effort,
          hashtags: form.hashtags
        )
      end
    end
  end
end

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
          sat_feedback = create_sat_feedback!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        sat_feedback.avatar.attach(form.avatar) if sat_feedback && form.avatar

        broadcast(:ok, sat_feedback)
      end

      private

      attr_reader :form, :sat_set, :sat_feedback

      def create_sat_feedback!
        attributes = {
          sat_set: sat_set,
          title: form.title,
          subtitle: form.subtitle,
          description: form.description,
          effort: form.effort,
          hashtags: form.hashtags,
          link_label: form.link_label,
          link_uri: form.link_uri
        }

        Indices::SatFeedback.create!(attributes)
      end
    end
  end
end

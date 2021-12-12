# frozen_string_literal: true

module Decidim
  module Admin
    class UpdateIndicesSatFeedback < Rectify::Command
      def initialize(form, sat_set, sat_feedback)
        @form = form
        @sat_set = sat_set
        @sat_feedback = sat_feedback
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          update_sat_feedback!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, sat_feedback)
      end

      private

      attr_reader :form, :sat_set, :sat_feedback

      def update_sat_feedback!
        @sat_feedback.sat_set = sat_set
        @sat_feedback.title = form.title
        @sat_feedback.description = form.description
        @sat_feedback.hashtags = form.hashtags
        @sat_feedback.save!
      end
    end
  end
end

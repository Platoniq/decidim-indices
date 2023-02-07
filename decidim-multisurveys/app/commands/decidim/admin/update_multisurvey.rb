# frozen_string_literal: true

module Decidim
  module Admin
    class UpdateMultisurvey < Rectify::Command
      def initialize(form, multisurvey)
        @form = form
        @multisurvey = multisurvey
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          update_multisurvey!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, multisurvey)
      end

      private

      attr_reader :form, :multisurvey

      def update_multisurvey!
        attributes = {
          title: form.title,
          survey_ids: form.survey_ids
        }

        multisurvey.update!(attributes)
      end
    end
  end
end

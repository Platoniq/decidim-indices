# frozen_string_literal: true

module Decidim
  module Admin
    class CreateMultisurvey < Rectify::Command
      def initialize(form)
        @form = form
      end

      def call
        return broadcast(:invalid) unless form.valid?

        begin
          multisurvey = create_multisurvey!
        rescue StandardError => e
          return broadcast(:invalid, e.message)
        end

        broadcast(:ok, multisurvey)
      end

      private

      attr_reader :form, :multisurvey

      def create_multisurvey!
        attributes = {
          title: form.title,
          survey_ids: form.survey_ids
        }

        Indices::Multisurvey.create!(attributes)
      end
    end
  end
end

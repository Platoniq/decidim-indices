# frozen_string_literal: true

module Decidim
  module Admin
    class MultisurveyForm < Form
      mimic "indices/multisurvey"

      attribute :name, String
      attribute :survey_ids, Array

      validates :name, presence: true
      validate :survey_ids_exist

      def survey_ids_exist
        # TODO
      end
    end
  end
end

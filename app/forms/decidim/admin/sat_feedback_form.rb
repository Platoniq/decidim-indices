# frozen_string_literal: true

module Decidim
  module Admin
    class SatFeedbackForm < Form
      include TranslatableAttributes
      include TranslationsHelper

      mimic "indices/sat_feedback"

      translatable_attribute :title, String
      translatable_attribute :subtitle, String
      translatable_attribute :description, String
      attribute :hashtags, Array
      attribute :effort, Integer
      attribute :avatar

      validates :title, translatable_presence: true
      validates :description, translatable_presence: true

      # convert hashtags to a proper json
      def self.from_params(params, additional_params = {})
        instance = super(params, additional_params)
        hashtags = instance.hashtags
        instance.hashtags = hashtags.first.map.with_index do |v, i|
          {
            "tag" => v.gsub("#", ""),
            "weight" => hashtags.second[i].presence || 10
          }
        end
        instance
      end
    end
  end
end

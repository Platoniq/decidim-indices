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
      attribute :effort, Integer, default: 0
      attribute :avatar
      attribute :remove_avatar, Boolean
      translatable_attribute :link_label, String
      attribute :link_uri, String

      validates :title, translatable_presence: true
      validates :description, translatable_presence: true
      validates :link_uri, url: true, presence: true, if: :has_link_label?
      validates :link_label, translatable_presence: true, if: :has_link_uri?

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

      def has_link_label?
        return false if link_label.nil?

        Decidim.available_locales.each do |locale|
          return true if link_label.with_indifferent_access[locale].present?
        end

        false
      end

      def has_link_uri?
        link_uri.present?
      end
    end
  end
end

# frozen_string_literal: true

module Decidim
  module Admin
    class SatFeedbackForm < Form
      include TranslatableAttributes
      include TranslationsHelper

      mimic "indices/sat_feedback"

      translatable_attribute :title, String
      translatable_attribute :description, String

      validates :title, translatable_presence: true
      validates :description, translatable_presence: true
    end
  end
end

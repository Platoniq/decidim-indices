# frozen_string_literal: true

module Indices
  class SatFeedbackCell < Decidim::ViewModel
    def title
      translated_attribute(model.title)
    end

    def subtitle
      translated_attribute(model.subtitle)
    end

    def description
      translated_attribute(model.description).html_safe
    end

    def effort
      return if model.effort.zero?

      Array.new(model.effort + 1).join("⚙️")
    end

    def key_words
      model.hashtags.collect { |a| a["tag"].prepend("#") }.join(" ")
    end
  end
end

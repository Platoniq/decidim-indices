# frozen_string_literal: true

# require "decidim/sanitize_helper"

module Indices
  class BaseParser
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TextHelper

    attr_accessor :content, :uri, :title, :date, :user_name, :category, :reply_of, :container
    attr_writer :content_type, :repository, :locale

    def content_type
      @content_type ||= "text/plain"
    end

    def repository
      @repository ||= "indices.weblyzard.com/api"
    end

    def locale
      @locale ||= Decidim.default_locale
    end

    def document
      {
        content: sanitize(content, scrubber: Decidim::UserInputScrubber.new),
        content_type: content_type,
        repository_id: repository,
        uri: uri,
        title: title,
        meta_data: metadata,
        features: features,
        relations: relations
      }
    end

    def json
      JSON.generate document
    end

    # used for comparative search, override depending on the specific document to obtain relevant results
    def keywords
      title
    end

    private

    def metadata
      {
        published_date: date.iso8601,
        user_name: user_name,
        language_id: locale
      }
    end

    def features
      feat = {}
      feat["category"] = category if category
      feat
    end

    def relations
      rel = {}
      rel["sioc:reply_of"] = reply_of if reply_of
      rel["sioc:has_container"] = container if container
      rel
    end
  end
end

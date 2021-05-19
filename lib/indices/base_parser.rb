# frozen_string_literal: true

# require "decidim/sanitize_helper"

module Indices
  class BaseParser
    include ActionView::Helpers::SanitizeHelper
    include ActionView::Helpers::TextHelper

    attr_accessor :content, :uri, :title, :date, :user_name, :category, :reply_of, :container, :errors, :resource, :resource_type, :resource_id
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
      model&.keywords || title
    end

    def valid?
      @errors = {}
      @errors[:title] = "Title is empty" if title.blank?
      @errors[:content] = "Content is empty" if content.blank?
      @errors[:date] = "Date is empty" if date.blank?

      @errors.blank?
    end

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

    # override in specific implementations if necessary
    def authored_by?(author)
      return false unless @resource

      @resource.try(:authored_by?, author)
    end

    def active?
      return true unless model

      model.active?
    end

    def model
      @model ||= WeblyzardLog.find_by(resource_type: resource_type, resource_id: resource_id)
    end

    def filter_defaults
      filter = {
        source: %w(decidim facebook news twitter web),
        begindate: (Date.current - 6.months).iso8601,
        enddate: Date.current.iso8601
      }
      filter.merge!(model.defaults.delete_if { |_k, v| v.blank? }.symbolize_keys) if model
      filter
    end
  end
end

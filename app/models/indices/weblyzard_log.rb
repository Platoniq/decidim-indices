# frozen_string_literal: true

module Indices
  # The data store for saving a reference to the Weblyzard dashbaord sync API
  class WeblyzardLog < ApplicationRecord
    self.table_name = "indices_weblyzard_log"

    def self.default_defaults
      {
        source: %w(decidim facebook news twitter web),
        action: "similarto",
        begindate: (Date.current - 6.months).iso8601
      }
    end

    def self.from_api(api)
      log = from_resource(resource_type: api.document.resource_type, resource_id: api.document.resource_id)
      log.uid = api.result["_id"]
      log.title = api.document.title
      log.content = api.document.content
      log.keywords = api.document.keywords
      log.uri = api.document.uri
      log.metadata = api.document.metadata
      log.features = api.document.features
      log.relations = api.document.relations
      log.defaults = default_defaults unless log.id
      log
    end

    def self.from_resource(resource_type:, resource_id:)
      log = find_or_initialize_by(resource_type: resource_type, resource_id: resource_id)
      log.uid = "" if log.uid.blank?
      log
    end

    def resource
      return unless resource_type

      klass = resource_type.constantize
      @resource ||= klass.find_by(id: resource_id)
    end
  end
end

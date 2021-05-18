# frozen_string_literal: true

module Indices
  # The data store for saving a reference to the Weblyzard dashbaord sync API
  class WeblyzardLog < ApplicationRecord
    self.table_name = "indices_weblyzard_log"

    def self.defaults
      {
        source: "decidim,facebook,news,twitter,web",
        action: "similarto",
        begindate: (Date.current - 6.months).iso8601
      }
    end

    def self.from_api(api)
      new(
        uid: api.result["_id"],
        title: api.document.title,
        content: api.document.content,
        keywords: api.document.keywords,
        uri: api.document.uri,
        metadata: api.document.metadata,
        features: api.document.features,
        relations: api.document.relations,
        defaults: defaults,
        resource_type: api.document.resource_type,
        resource_id: api.document.resource_id
      )
    end
  end
end

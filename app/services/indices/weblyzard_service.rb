# frozen_string_literal: true

module Indices
  module WeblyzardService
    include ActiveSupport::Configurable

    config_accessor :username, :password

    config_accessor :repository_id do
      "indices.weblyzard.com/api"
    end

    config_accessor :token_time do
      8 * 3600
    end

    def self.api
      @api ||= WeblyzardApi.new config
    end

    def self.publish(document)
      result = api.post_document(document)
      return nil unless result

      save_log(api)
      result
    end

    def self.save_log(api)
      WeblyzardLog.from_api(api).save!
    end
  end
end

# frozen_string_literal: true

module Indices
  class WeblyzardService
    include ActiveSupport::Configurable

    config_accessor :username, :password

    config_accessor :repository_id do
      "indices.weblyzard.com/api"
    end

    config_accessor :token_time do
      8 * 3600
    end

    attr_accessor :document
    attr_reader :result, :error

    def initialize(document)
      @document = document
    end

    def api
      @api ||= WeblyzardApi.new WeblyzardService.config
    end

    def publish
      @result = api.post_document(document)
      return nil unless @result

      @result = api.put_document(@result["existing_id"], document) if @result["existing_id"]

      WeblyzardLog.from_api(api).save!
    rescue StandardError => e
      @error = e.message
      nil
    end
  end
end

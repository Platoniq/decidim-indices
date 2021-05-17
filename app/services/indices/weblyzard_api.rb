# frozen_string_literal: true

module Indices
  class WeblyzardApi
    attr_accessor :username, :password, :token_time, :repository_id

    def initialize(username:, password:, token_time:, repository_id:)
      @username = username
      @password = password
      @token_time = token_time
      @repository_id = repository_id
    end

    def connection
      @connection ||= Faraday.new(
        url: "https://api.weblyzard.com/1.0/documents/#{@repository_id}",
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{token}"
        }
      )
    end

    # obtain a valid token
    # TODO: cache it during the token_time time span
    def token
      conn = Faraday.new(url: "https://api.weblyzard.com/1.0/token")
      conn.basic_auth username, password
      resp = conn.get
      resp.body
    end

    def post_document(json)
      connection.post do |req|
        req.body = json
      end
    end
  end
end

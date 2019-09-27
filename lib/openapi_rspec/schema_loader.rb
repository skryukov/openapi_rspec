# frozen_string_literal: true

module OpenapiRspec
  module SchemaLoader
    def self.call(path, app: OpenapiRspec.config.app)
      response = request(path, app)
      parse(response)
    end

    def self.parse(schema)
      begin
        JSON.parse(schema)
      rescue JSON::ParserError
        YAML.safe_load(schema)
      end
    rescue StandardError => e
      raise "Unable to parse OpenAPI schema. #{e}"
    end

    def self.request(path, app)
      session = Rack::Test::Session.new(app)
      response = session.get(path)

      raise "Response code: #{response.status}" unless response.successful?
      raise 'Empty body' if response.body.empty?

      response.body
    rescue StandardError => e
      raise "Unable to perform GET request for the OpenAPI schema '#{path}'. #{e}"
    end
  end
end

require "dry-configurable"
require "openapi_validator"
require "rspec"

require "openapi_rspec/helpers"
require "openapi_rspec/matchers"
require "openapi_rspec/module_helpers"
require "openapi_rspec/version"

module OpenapiRspec
  extend Dry::Configurable

  setting :app, reader: true

  def self.api(doc, **params)
    OpenapiValidator.call(doc, **params)
  end

  def self.api_by_path(openapi_path, **params)
    session = Rack::Test::Session.new(config.app)
    begin
      response = session.get(openapi_path)
    rescue StandardError => e
      raise "Unable to perform GET request for swagger json: #{openapi_path} - #{e}."
    end

    parsed_doc = case openapi_path.split(".").last
                 when "yml", "yaml"
                   YAML.load(response.body)
                 when "json"
                   JSON.parse(response.body)
                 else
                   raise "Unable to parse OpenAPI doc, '#{openapi_path}' is undefined format"
                 end
    OpenapiValidator.call(parsed_doc, **params)
  end

  RSpec.configure do |config|
    config.extend ModuleHelpers
    config.include Helpers
    config.include Matchers
  end
end

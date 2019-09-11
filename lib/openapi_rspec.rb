require "dry-configurable"
require "openapi_validator"
require "openapi_builder"
require "rspec"

require "openapi_rspec/helpers"
require "openapi_rspec/matchers"
require "openapi_rspec/module_helpers"
require "openapi_rspec/version"

module OpenapiRspec
  extend Dry::Configurable

  setting :app, reader: true

  def self.api(doc, build: false, **params)
    doc = OpenapiBuilder.call(doc).data if build
    OpenapiValidator.call(doc, **params)
  end

  def self.api_by_path(openapi_path, **params)
    session = ActionDispatch::Integration::Session.new(Rails.application)
    begin
      session.get(openapi_path)
    rescue StandardError
      raise "Unable to perform GET request for swagger json: #{openapi_path} - #{$ERROR_INFO}."
    end
    parsed_doc = JSON.parse(session.response.body)
    OpenapiValidator::Validator.new(parsed_doc, **params)
  end

  RSpec.configure do |config|
    config.extend ModuleHelpers
    config.include Helpers
    config.include Matchers
  end
end

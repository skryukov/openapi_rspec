require "dry-configurable"
require "openapi_validator"
require "rspec"

require "openapi_rspec/helpers"
require "openapi_rspec/matchers"
require "openapi_rspec/module_helpers"
require "openapi_rspec/schema_loader"
require "openapi_rspec/version"

module OpenapiRspec
  extend Dry::Configurable

  setting :app, reader: true

  def self.api(doc, **params)
    OpenapiValidator.call(doc, **params)
  end

  def self.api_by_path(path, **params)
    doc = SchemaLoader.call(path)
    api(doc, **params)
  end

  RSpec.configure do |config|
    config.extend ModuleHelpers
    config.include Helpers
    config.include Matchers
  end
end

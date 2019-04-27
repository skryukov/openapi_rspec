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

  RSpec.configure do |config|
    config.extend ModuleHelpers
    config.include Helpers
    config.include Matchers
  end
end

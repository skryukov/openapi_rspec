# frozen_string_literal: true

require 'openapi_rspec/documentation_validator'
require 'openapi_rspec/request_validator'

module OpenapiRspec
  module Matchers
    def validate_documentation
      DocumentationValidator.new
    end

    def validate_request(**attrs)
      RequestValidator.new(**attrs)
    end
  end
end

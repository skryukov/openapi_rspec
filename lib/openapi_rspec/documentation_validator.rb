# frozen_string_literal: true

module OpenapiRspec
  class DocumentationValidator
    def matches?(doc)
      @result = doc.validate_documentation
      @result.valid?
    end

    def description
      'be a valid documentation'
    end

    def failure_message
      @result.errors.join("\n")
    end
  end
end

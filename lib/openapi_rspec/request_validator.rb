# frozen_string_literal: true

require 'dry-initializer'
require 'rack/test'
require 'uri'

module OpenapiRspec
  class RequestValidator
    extend Dry::Initializer
    include Rack::Test::Methods

    option :path
    option :method
    option :code
    option :media_type
    option :params
    option :query
    option :headers

    attr_reader :response, :result

    def app
      OpenapiRspec.app
    end

    def matches?(doc)
      @result = doc.validate_request(path: path, method: method, code: code, media_type: media_type)
      return false unless result.valid?

      perform_request(doc)
      result.validate_response(body: response.body, code: response.status)
      result.valid?
    end

    def description
      "return valid response with code #{code} on `#{method.to_s.upcase} #{path}`"
    end

    def failure_message
      if response
        (%W[Response: #{response.body}] + result.errors).join("\n")
      else
        result.errors.join("\n")
      end
    end

    private

    def request_uri(doc)
      path.scan(/\{([^\}]*)\}/).each do |param|
        key = param.first.to_sym
        if params && params[key]
          @path = path.gsub "{#{key}}", params.delete(key).to_s
        else
          raise URI::InvalidURIError, "No substitution data found for {#{key}}"\
            " to test the path #{path}."
        end
      end
      "#{doc.api_base_path}#{path}?#{URI.encode_www_form(query)}"
    end

    def perform_request(doc)
      headers.each do |key, value|
        header key, value
      end
      request(request_uri(doc), method: method, **request_params)
      @response = last_response
    end

    def request_params
      {
        headers: headers,
        params: params
      }
    end
  end
end

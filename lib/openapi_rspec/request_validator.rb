require "rack/test"
require "uri"

module OpenapiRspec
  class RequestValidator
    include Rack::Test::Methods

    def app
      OpenapiRspec.app
    end

    def initialize(path:, method:, code:, params: {}, query: {}, headers: {})
      @path = path
      @method = method
      @code = code
      @query = query
      @headers = headers
      @params = params
    end

    attr_reader :method, :path, :code, :query, :headers, :params

    def matches?(doc)
      @result = doc.validate_request(path: path, method: method, code: code)
      return false unless @result.valid?

      headers.each do |key, value|
        header key, value
      end
      request(request_uri(doc), method: method, **request_params)
      @response = last_response
      @result.validate_response(body: @response.body, code: @response.status)
      @result.valid?
    end

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

    def request_params
      {
        headers: headers,
        params: params,
      }
    end

    def description
      "return valid response with code #{code} on `#{method.to_s.upcase} #{path}`"
    end

    def failure_message
      if @response
        (%W(Response: #{@response.body}) + @result.errors).join("\n")
      else
        @result.errors.join("\n")
      end
    end
  end
end

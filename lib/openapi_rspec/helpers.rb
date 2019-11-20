# frozen_string_literal: true

module OpenapiRspec
  module Helpers
    def request_params(metadata)
      path = defined?(uri) ? uri : metadata[:uri]
      method = defined?(http_method) ? http_method : metadata[:method]
      params = if openapi_rspec_params.is_a?(Hash)
        path_params(path).merge!(openapi_rspec_params)
      else
        openapi_rspec_params
      end

      {
        method: method,
        path: path,
        params: params,
        headers: openapi_rspec_headers,
        query: openapi_rspec_query,
        media_type: openapi_rspec_media_type,
      }
    end

    def path_params(path)
      path_params = {}
      path.scan(/\{([^\}]*)\}/).each do |param|
        key = param.first.to_sym
        path_params[key] = public_send(key) if respond_to?(key)
      end
      path_params
    end
  end
end

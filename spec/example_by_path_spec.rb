require "openapi_rspec"
require "./spec/support/hello_world_app.rb"

OpenapiRspec.config.app = HelloWorldApp.new

RSpec.describe "API v1 (by path)" do
  subject { OpenapiRspec.api_by_path("/openapi.yml", api_base_path: "/v1") }

  it "is valid openapi spec" do
    expect(subject).to validate_documentation
  end

  get "/pets" do
    headers { { "X-Client-Device" => "ios" } }
    query { { tags: ["lucky"] } }

    validate_code(200) do |validator|
      result = JSON.parse(validator.response.body)
      expect(result.first["name"]).to eq("Lucky")
    end
  end
end


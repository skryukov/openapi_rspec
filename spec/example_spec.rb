# frozen_string_literal: true

require "openapi_rspec"

OpenapiRspec.config.app = HelloWorldApp.new

RSpec.describe "API v1" do
  # do not forget additional_schemas
  subject { OpenapiRspec.api("./spec/data/openapi.yml", api_base_path: "/v1") }

  it "is valid openapi spec" do
    expect(subject).to validate_documentation
  end

  get "/pets" do
    headers { {"X-Client-Device" => "ios"} }
    query { {tags: ["lucky"]} }

    validate_code(200) do |validator|
      result = JSON.parse(validator.response.body)
      expect(result.first["name"]).to eq("Lucky")
    end
  end

  post "/pets" do
    params { {name: "Lucky"} }

    validate_code(200)
  end

  get "/pets/{id}" do
    let(:id) { 23 }
    params { {name: "Lucky"} }

    validate_code(200)
  end
end

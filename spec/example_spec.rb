require "openapi_rspec"

class HelloWorld
  def call(env)
      [200, {"Content-Type" => "application/json"}, ['[{"id": 23, "name": "Lucky"}]']]
  end
end

OpenapiRspec.config.app = HelloWorld.new

RSpec.describe "API v1" do
  # do not forget additional_schemas
  subject { OpenapiRspec.api("./spec/data/openapi.yml", build: false, api_base_path: "/v1") }

  it "is valid openapi spec" do
    expect(subject).to validate_documentation
  end

  get "/pets" do
    headers { { "X-Client-Device" => "ios" } }
    query { { tags: ["lucky"] } }

    validate_code(200)
  end

  post "/pets" do
    params { { name: "Lucky" } }

    validate_code(200)
  end

  get "/pets/{id}" do
    let(:id) { 23 }
    params { { name: "Lucky" } }

    validate_code(200)
  end
end
require "openapi_rspec"

class HelloWorld
  def call(env)
      [200, {"Content-Type" => "application/json"}, ['[{"id": 23, "name": "Misha"}]']]
  end
end

OpenapiRspec.config.app = HelloWorld.new

RSpec.describe "API v1" do
  # do not forget additional_schemas
  subject { OpenapiRspec.api("./spec/data/openapi.yml", build: false, api_base_path: "/v1") }

  it "is valid openapi spec" do
    expect(subject).to validate_documentation
  end

  context "/pets" do
    let(:uri) { "/pets" }
    let(:method) { :get }

    specify do
      expect(subject).to validate_request(method: method, path: uri, code: 200)
    end
  end
end
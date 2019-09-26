[gem]: https://rubygems.org/gems/openapi_rspec
[travis]: https://travis-ci.org/medsolutions/openapi_rspec
[codeclimate]: https://codeclimate.com/github/medsolutions/openapi_rspec

# openapi_rspec
[![Gem Version](https://badge.fury.io/rb/openapi_rspec.svg)][gem]
[![Build Status](https://travis-ci.org/medsolutions/openapi_rspec.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/medsolutions/openapi_rspec/badges/gpa.svg)][codeclimate]
[![Test Coverage](https://codeclimate.com/github/medsolutions/openapi_rspec/badges/coverage.svg)][codeclimate]

Test your API against OpenApi v3 documentation

Inspired by [Apivore](https://github.com/westfieldlabs/apivore)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openapi_rspec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openapi_rspec

## Usage

Add `spec/openapi_helper.rb` and set `OpenapiRspec.config.app`:

```ruby
# spec/openapi_helper.rb

require "rails_helper"

OpenapiRspec.config.app = Rails.application # or any other Rack app, thanks to rack-test gem
```

Then configure path to your documentation. You can use documentation defined as:
- static file with `.yaml`/`.yml` or `.json` extension
- path in your application with `.yaml`/`.yml` or `.json` extension

```ruby
# spec/openapi_helper.rb

#...

# static file
API_V1 = OpenapiRspec.api("./spec/data/openapi.yml")

# application path
API_V2 = OpenapiRspec.api_by_path("/openapi.json")
```


### Validate documentation against the OpenAPI 3.0 Specification:

```ruby
RSpec.describe "API v1" do
  subject { API_V1 }

  it "is valid OpenAPI spec" do
    expect(subject).to validate_documentation
  end
end
```

#### Validate documentation against custom schema

You can validate documentation against additional custom schemata, for example, to enforce organization documentation standards:

```ruby
# spec/openapi_helper.rb

#...

API_V1 = OpenapiRspec.api("./spec/data/openapi.yml", additional_schemas: ["./spec/data/acme_schema.yml"])
```

```ruby
# openapi_v1_spec.rb

RSpec.describe "API v1" do
  subject { API_V1 }

  it "is valid OpenAPI and ACME spec" do
    expect(subject).to validate_documentation
  end
end
```

### Validate endpoints

General example:

```ruby
require "openapi_rspec"

RSpec.describe "API v1 /pets" do

  subject { API_V1 }

  get "/pets" do
    headers { { "X-Client-Device" => "ios" } }
    query { { tags: ["lucky"] } }

    validate_code(200) do |validator|
      result = JSON.parse(validator.response.body)
      expect(result.first["name"]).to eq("Lucky")
    end
  end

  post "/pets" do
    params { { name: "Lucky" } }

    validate_code(201)
  end

  get "/pets/{id}" do
    let(:id) { 23 }

    validate_code(200)

    context "when pet not found" do
      let(:id) { "bad_id" }

      validate_code(404)
    end
  end
```

#### Helper methods

To validate response use:
- `get`, `post`, `put`, `patch`, `delete` and `head` methods to describe operation with the path
- `validate_code` method with passed expected code

```ruby
# ...
  get "/pets" do
    validate_code(200)
  end
# ...
```

To set **request body** use `params` helper method:

```ruby
# ...
  post "/pets" do
    params { { name: "Lucky" } }

    validate_code(201)
  end
# ...
```

To set **path parameter** use `let` helper method:

```ruby
# ...
  get "/pets/{id}" do
    let(:id) { 23 }

    validate_code(200)
  end
# ...
```

To set **query parameters** use `query` helper method:

```ruby
# ...
  get "/pets" do
    query { { name: "lucky" } }

    validate_code(200)
  end
# ...
```

To set **header parameters** use `headers` helper method:

```ruby
# ...
  get "/pets" do
    headers { { "X-User-Token" => "bad_token" } }

    validate_code(401)
  end
# ...
```

#### Custom response validation

You can access response to add custom validation like this:

```ruby
# ...
  get "/pets" do
    validate_code(200) do |validator|
      result = JSON.parse(validator.response.body)
      expect(result).not_to be_empty
    end
  end
# ...
```

#### Prefix API requests

To prefix each request with `"/some_path"` use `:api_base_path` option:

```ruby
# spec/openapi_helper.rb

#...

API_V1 = OpenapiRspec.api("./spec/data/openapi.yml", api_base_path: "/some_path")
```

#### Validate that all documented routes are tested

To validate this we will use a small hack:

```ruby
# spec/openapi_helper.rb

# ...

API_V1_DOC = OpenapiRspec.api("./openapi/openapi.yml", api_base_path: "/api/v1")

RSpec.configure do |config|
  config.after(:suite) do
    unvalidated_requests = API_V1_DOC.unvalidated_requests

    if unvalidated_requests.any? && ENV["TEST_COVERAGE"]
      raise unvalidated_requests.map { |path| "Path #{path.join(' ')} not tested" }.join("\n")
    end
  end
end
```

Then run your specs:

    $ TEST_COVERAGE=1 rspec

This will raise an error if any of the documented paths are not validated.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/medsolutions/openapi_rspec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

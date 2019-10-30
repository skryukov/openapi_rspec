# frozen_string_literal: true

class HelloWorldApp
  def call(env)
    case env["PATH_INFO"]
    when "/openapi.yml"
      [200, {}, [File.read("./spec/data/openapi.yml")]]
    when /pets.*/
      [200, {"Content-Type" => "application/json"}, ['[{"id": 23, "name": "Lucky"}]']]
    when "/bad.yaml"
      [200, {}, [":"]]
    when "/no_content"
      [204, {}, []]
    else
      [404, {}, []]
    end
  end
end

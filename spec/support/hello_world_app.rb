# frozen_string_literal: true

class HelloWorldApp
  def call(env)
    case env["PATH_INFO"]
    when "/openapi.yml"
      [200, {}, [File.read("./spec/data/openapi.yml")]]
    when /pets.*/
      case env["REQUEST_METHOD"]
      when "GET"
        [200, {"Content-Type" => "application/json"}, ['[{"id": 23, "name": "Lucky"}]']]
      when "POST"
        request = Rack::Request.new(env)

        data = if request.form_data?
          request.params
        else
          JSON.parse(request.body.string)
        end

        lucky = data["id"] = 23
        [200, {"Content-Type" => "application/json"}, [JSON.dump(lucky)]]
      else
        [405, {}, []]
      end
    when "/bad.yaml"
      [200, {}, [":"]]
    when "/no_content"
      [204, {}, []]
    else
      [404, {}, []]
    end
  end
end

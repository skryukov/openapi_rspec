class HelloWorldApp
  def call(env)
    if env["PATH_INFO"] == "/openapi.yml"
      [200, {}, [File.read("./spec/data/openapi.yml")]]
    else
      [200, { "Content-Type" => "application/json" }, ['[{"id": 23, "name": "Lucky"}]']]
    end
  end
end

# frozen_string_literal: true

if RUBY_ENGINE == "ruby" && ENV["COVERAGE"] == "true"
  require "yaml"
  rubies = YAML.safe_load(File.read(File.join(__dir__, "..", ".travis.yml")))["rvm"]
  latest_mri = rubies.select { |v| v =~ /\A\d+\.\d+.\d+\z/ }.max

  if RUBY_VERSION == latest_mri
    require "simplecov"
    SimpleCov.start do
      add_filter "/spec/"
    end
  end
end

require "bundler/setup"
require "openapi_rspec"
require "support/hello_world_app"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openapi_rspec/version'

Gem::Specification.new do |spec|
  spec.name = 'openapi_rspec'
  spec.version = OpenapiRspec::VERSION
  spec.authors = ['Svyatoslav Kryukov']
  spec.email = ['s.g.kryukov@yandex.ru']

  spec.summary = 'Test your API against OpenApi v3 documentation'
  spec.homepage = 'https://github.com/medsolutions/openapi_rspec'
  spec.license = 'MIT'

  spec.files = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.executables = []
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4'

  spec.add_runtime_dependency 'dry-configurable', '>= 0.8'
  spec.add_runtime_dependency 'openapi_validator', '>= 0.3'
  spec.add_runtime_dependency 'rack-test', '~> 1.1'
  spec.add_runtime_dependency 'rspec', '~> 3.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end

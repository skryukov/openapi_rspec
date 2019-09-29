# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OpenapiRspec::SchemaLoader do
  subject { OpenapiRspec::SchemaLoader }
  let(:app) { HelloWorldApp.new }

  it 'loads yaml schema' do
    result = subject.call('/openapi.yml', app: app)

    expect(result).to be_a(Hash)
    expect(result['info']['title']).to eq('Swagger Petstore')
  end

  context 'when unsuccessful response code' do
    it 'raises an error' do
      expect { subject.call('/bad_url', app: app) }.to raise_error(/Response code: 404/)
    end
  end

  context 'when empty body' do
    it 'raises an error' do
      expect { subject.call('/no_content', app: app) }.to raise_error(/Empty body/)
    end
  end

  context 'when wrong yaml format' do
    it 'raises an error' do
      expect { subject.call('/bad.yaml', app: app) }
        .to raise_error(/Unable to parse OpenAPI schema/)
    end
  end
end

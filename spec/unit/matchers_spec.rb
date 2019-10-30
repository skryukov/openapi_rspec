# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenapiRspec::Matchers do
  before(:each) do
    class Foo
      include OpenapiRspec::Matchers
    end
  end

  after(:each) do
    Object.send(:remove_const, :Foo)
  end

  subject { Foo.new }

  context "#validate_documentation" do
    it "returns new DocumentationValidator instance" do
      allow(OpenapiRspec::DocumentationValidator).to receive(:new).and_return("result")

      result = subject.validate_documentation

      expect(result).to eq("result")
      expect(OpenapiRspec::DocumentationValidator).to have_received(:new).with no_args
    end
  end

  context "#validate_request" do
    it "returns new RequestValidator instance" do
      allow(OpenapiRspec::RequestValidator).to receive(:new).and_return("result")

      result = subject.validate_request(some: "params")

      expect(result).to eq("result")
      expect(OpenapiRspec::RequestValidator).to have_received(:new).with(some: "params")
    end
  end
end

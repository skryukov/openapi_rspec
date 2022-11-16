# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenapiRspec::Matchers do
  subject do
    Class.new { include OpenapiRspec::Matchers }.new
  end

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

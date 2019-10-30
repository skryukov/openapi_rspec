# frozen_string_literal: true

require "spec_helper"

RSpec.describe OpenapiRspec::DocumentationValidator do
  subject { OpenapiRspec::DocumentationValidator.new }

  let(:doc) { instance_double(OpenapiValidator::Validator, validate_documentation: result_obj) }
  let(:result_obj) do
    instance_double(OpenapiValidator::DocumentationValidator,
      valid?: validation_result,
      errors: %w[first second])
  end

  context "#description" do
    it "returns a string" do
      expect(subject.description).to eq("be a valid OpenAPI documentation")
    end
  end

  context "#failure_message" do
    let(:validation_result) { false }

    it "returns joined errors" do
      subject.matches?(doc)
      expect(subject.failure_message).to eq("first\nsecond")
    end
  end

  context "#matches?" do
    context "when doc is valid" do
      let(:validation_result) { true }

      it "returns true" do
        result = subject.matches?(doc)

        expect(result).to be(true)
      end
    end

    context "when doc is not valid" do
      let(:validation_result) { false }

      it "returns true" do
        result = subject.matches?(doc)

        expect(result).to be(false)
      end
    end
  end
end

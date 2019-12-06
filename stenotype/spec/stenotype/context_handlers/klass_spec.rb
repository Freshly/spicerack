# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers::Klass do
  describe ".handler_name" do
    let(:handler_klass) { described_class }

    subject(:handler_name) { handler_klass.handler_name }

    it "equals to :klass" do
      expect(handler_name).to eq(:klass)
    end
  end

  describe "#as_json" do
    let(:context) { object_double(:context) }
    let(:handler) { described_class.new(context) }

    subject(:as_json) { handler.as_json }

    it "returns json representation of context" do
      expect(as_json).to eq({})
    end
  end
end

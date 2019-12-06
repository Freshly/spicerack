# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers::Rails::Controller do
  let(:dummy_controller) do
    Class.new(ActionController::Base) do
      class << self
        def name
          "DummyController"
        end
      end
    end
  end

  let(:request) { ActionDispatch::TestRequest.create }
  let(:response) { ActionDispatch::TestResponse.new }
  let(:controller_instance) { dummy_controller.new }

  subject(:context_handler) { described_class.new(controller_instance) }

  describe "#as_json" do
    before do
      allow(controller_instance).to receive(:request).and_return(request)
      allow(request).to receive(:controller_class).and_return(dummy_controller)

      controller_instance.action_name = "index"
      controller_instance.set_response!(response)
    end

    let(:expected_result) do
      {
        class: "DummyController",
        ip: "0.0.0.0",
        method: "GET",
        params: {},
        referer: nil,
        url: "http://test.host/",
      }
    end

    it "casts controller data to JSON" do
      expect(context_handler.as_json).to eq(expected_result)
    end
  end
end

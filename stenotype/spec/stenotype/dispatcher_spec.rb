# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Dispatcher do
  describe "#publish" do
    let(:dummy_serializer) do
      Class.new do
        attr_reader :event

        def initialize(event)
          @event = event
        end

        def serialize
          { dummy_key: "dummy value" }
        end
      end
    end

    let(:test_target) { Stenotype::TestAdapter.new }
    let(:event) { Stenotype::Event.new("dummy data") }

    subject(:dispatcher) { described_class.new }

    before do
      Stenotype.configure { |config| config.targets = [ test_target ] }
      allow(test_target).to receive(:publish)
    end

    it "dispatches the event to configured targets" do
      dispatcher.publish(event, serializer: dummy_serializer)

      expect(test_target).to have_received(:publish).with(dummy_key: "dummy value")
    end
  end
end

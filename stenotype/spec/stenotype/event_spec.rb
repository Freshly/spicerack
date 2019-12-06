# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Event do
  let(:test_dispatcher_klass) do
    Class.new do
      def publish(event)
        event
      end
    end
  end

  let!(:test_dispatcher) { test_dispatcher_klass.new }

  before do
    allow(test_dispatcher_klass).to receive(:new).and_return(test_dispatcher)
    allow(test_dispatcher).to receive(:publish)

    Stenotype.configure { |config| config.dispatcher = test_dispatcher_klass }
  end

  after do
    Stenotype.configure { |config| config.dispatcher = Stenotype::Dispatcher }
  end

  describe ".emit!" do
    it "delegates emit! to instance of #{described_class}" do
      described_class.emit!(event: :data)

      expect(test_dispatcher).to have_received(:publish)
    end

    it "returns event" do
      result = described_class.emit!(event: :data)

      expect(result).to be_a(described_class)
      expect(test_dispatcher).to have_received(:publish)
    end
  end

  describe "#emit!" do
    subject(:event) { described_class.new(event: :data) }

    it "delegates the event to a dispatcher" do
      event.emit!
      expect(test_dispatcher).to have_received(:publish)
    end
  end
end

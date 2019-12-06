# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers::Collection do
  subject(:collection) { described_class.new }

  let(:handler) do
    Class.new(Stenotype::ContextHandlers::Base) do
      self.handler_name = :handler

      class << self
        def name
          "DummyHandler"
        end
      end
    end
  end

  describe "#choose" do
    context "when a handler is registered" do
      before { collection.register(handler) }

      it "returns it" do
        expect(collection.choose(handler_name: :handler).name).to eq("DummyHandler")
      end
    end

    context "when a handler is not registered" do
      it "raises" do
        expect { collection.choose(handler_name: :unknown) }.to raise_error(Stenotype::UnknownHandlerError)
      end
    end
  end

  describe "#register" do
    subject(:register) { collection.register(handler) }

    it "adds it to collection" do
      expect { register }.to change { collection.items }.to([ handler ])
    end
  end

  describe "#unregister" do
    before { collection.register(handler) }

    subject(:unregister) { collection.unregister(handler) }

    it "removes a handler from collection" do
      expect { unregister }.to change { collection.items }.to([])
    end
  end

  describe "registered?" do
    context "when a handler is present in the collection" do
      before { collection.register(handler) }

      subject(:registered?) { collection.registered?(handler) }

      it { is_expected.to eq(true) }
    end

    context "when a handler is not present in the collection" do
      it "returns false" do
        expect(collection).not_to be_registered(handler)
      end
    end
  end
end

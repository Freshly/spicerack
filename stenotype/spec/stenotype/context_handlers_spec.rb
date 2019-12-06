# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers do
  subject(:context_handlers) { described_class }

  describe ".known" do
    context "when no handler(s) specified" do
      before { context_handlers.known = nil }

      after { described_class.reset_defaults! }

      it "returns an empty handlers collection" do
        expect(context_handlers.known).to be_empty
        expect(context_handlers.known).to be_a(::Collectible::CollectionBase)
      end
    end

    context "when there are registered handlers" do
      let(:test_handler) { Stenotype::TestHandler }

      before do
        context_handlers.known = nil
        context_handlers.register test_handler
      end

      after { described_class.reset_defaults! }

      it "returns the collection of handlers" do
        expect(context_handlers.known).to match_array([ test_handler ])
      end
    end
  end

  describe ".register" do
    let(:test_handler) { Stenotype::TestHandler }

    before { context_handlers.known = nil }

    after { described_class.reset_defaults! }

    it "registers a handler in the list of known handlers" do
      expect(context_handlers.known).to be_empty
      context_handlers.register test_handler
      expect(context_handlers.known).to match_array([ test_handler ])
    end
  end
end

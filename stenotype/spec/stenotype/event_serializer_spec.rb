# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::EventSerializer do
  subject(:serializer) { described_class.new(event, uuid_generator: Stenotype::TestUuidGen) }

  let(:data) { { data_key: "data value" } }
  let(:options) { { options_key: "options value" } }
  let(:eval_context) { { klass: dummy_context.new } }

  let(:event) do
    Stenotype::Event.new(
      data,
      options: options,
      eval_context: eval_context,
    )
  end

  let(:dummy_context) { Class.new }

  describe "#serialize", type: :with_frozen_time do
    it "represents an event as a hash" do
      expect(serializer.serialize).to eq(
        data_key: "data value",
        options_key: "options value",
        timestamp: Time.now.utc,
        uuid: "abcd",
      )
    end
  end
end

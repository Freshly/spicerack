# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::Base do
  describe "#publish" do
    let(:klass) { Class.new(described_class) }
    let(:klass_instance) { klass.new }
    let(:event_data) { object_double(:event_data) }

    subject(:publish) { klass_instance.publish(event_data) }

    context "when not implemented" do
      it "raises NotImplementedError" do
        expect { publish }.to raise_error(NotImplementedError)
      end
    end

    context "when a subclass implements method #publish" do
      before do
        klass.class_eval do
          def publish(*_args)
            # do nothing
            true
          end
        end
      end

      it "does not raise" do
        expect(publish).to eq(true)
      end
    end
  end
end

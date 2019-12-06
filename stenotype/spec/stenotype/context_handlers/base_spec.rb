# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::ContextHandlers::Base do
  let(:dummy_handler_class) { Class.new(described_class) }

  describe "#as_json" do
    let(:context) { object_double(:context) }
    let(:dummy_handler_instance) { dummy_handler_class.new(context) }

    subject(:as_json) { dummy_handler_instance.as_json }

    context "when it is not implemented" do
      it "raises" do
        expect { as_json }.to raise_error(NotImplementedError)
      end
    end
  end

  describe ".handler_name=" do
    subject(:dummy_handler) { dummy_handler_class }

    it { is_expected.to have_attr_accessor(:handler_name) }
  end

  describe ".handler_name" do
    context "when not set" do
      subject(:handler_name) { dummy_handler_class.handler_name }

      it "raises" do
        expect { handler_name }.to raise_error(NotImplementedError)
      end
    end
  end
end

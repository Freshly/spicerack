# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Emitter, type: :with_frozen_time do
  subject(:dummy_klass) do
    Class.new do
      include Stenotype::Emitter

      emit_event_before :some_method
      emit_klass_event_before :some_class_method

      def some_method
        :result_of_some_method
      end

      def emit_manually
        emit_event
      end

      def to_be_aliased
        emit_event
      end

      alias_method :aliased, :to_be_aliased

      class << self
        def name
          "DummyKlass"
        end

        def some_class_method
          :result_of_class_method
        end
      end
    end
  end

  describe "class methods" do
    it "include emit_event_before" do
      expect(dummy_klass).to respond_to(:emit_event_before)
    end
  end

  describe "instance methods" do
    it "include emit_event" do
      expect(dummy_klass.new).to respond_to(:emit_event)
    end
  end

  describe "#emit_event" do
    let(:test_buffer) { [] }
    let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

    before { Stenotype.configure { |config| config.targets = [ test_target ] } }

    context "when called in a regular method" do
      let(:expected_event_data) do
        {
          class: "DummyKlass",
          method: :emit_manually,
          timestamp: Time.now.utc,
          type: "class_instance",
          uuid: "abcd",
        }
      end

      subject(:emit_manually) { dummy_klass.new.emit_manually }

      it "manually emits an event" do
        expect { emit_manually }.to change { test_buffer }.to([ expected_event_data ])
      end
    end

    context "when called in an aliased method" do
      let(:expected_event_data) do
        {
          class: "DummyKlass",
          method: :to_be_aliased,
          timestamp: Time.now.utc,
          type: "class_instance",
          uuid: "abcd",
        }
      end

      subject(:emit_aliased) { dummy_klass.new.aliased }

      it "manually emits an event" do
        expect { emit_aliased }.to change { test_buffer }.to([ expected_event_data ])
      end
    end
  end

  describe "method" do
    let(:test_buffer) { [] }
    let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

    before { Stenotype.configure { |config| config.targets = [ test_target ] } }

    context "when being an instance method" do
      let(:expected_event_data) do
        {
          type: "class_instance",
          class: "DummyKlass",
          method: :some_method,
          timestamp: Time.now.utc,
          uuid: "abcd",
        }
      end

      subject(:trigger_from_method) { dummy_klass.new.some_method }

      it "is wrapped with an event trigger" do
        expect { trigger_from_method }.to change { test_buffer }.to([ expected_event_data ])
      end
    end

    context "when being a class method" do
      let(:expected_event_data) do
        {
          type: "class",
          class: "DummyKlass",
          method: :some_class_method,
          timestamp: Time.now.utc,
          uuid: "abcd",
        }
      end

      subject(:trigger_from_class_method) { dummy_klass.some_class_method }

      it "is wrapped with an event trigger" do
        expect { trigger_from_class_method }.to change { test_buffer }.to([ expected_event_data ])
      end
    end
  end
end

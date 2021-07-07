# frozen_string_literal: true

RSpec.describe Substance::RootObject do
  subject { described_class }

  it { is_expected.to include_module ActiveSupport::Callbacks }
  it { is_expected.to include_module ShortCircuIt }
  it { is_expected.to include_module Technologic }
  it { is_expected.to include_module Tablesalt::StringableObject }

  describe ".define_callbacks_with_handler" do
    let(:example_class) { Class.new(described_class) }

    shared_examples_for "callbacks and handler are defined for event" do
      let(:expected_events) { [ event ] }

      it "defines callbacks" do
        expect { define_callbacks_with_handler }.
          to change { example_class.__callbacks.keys }.
          from([]).
          to(expected_events)
      end
    end

    context "with no options" do
      context "with one event" do
        subject(:define_callbacks_with_handler) { example_class.__send__(:define_callbacks_with_handler, event) }

        let(:event) { Faker::Internet.domain_word.underscore.to_sym }

        it_behaves_like "callbacks and handler are defined for event"
      end

      context "with several events" do
        subject(:define_callbacks_with_handler) do
          example_class.__send__(:define_callbacks_with_handler, event1, event2)
        end

        let(:event1) { Faker::Internet.unique.domain_word.underscore.to_sym }
        let(:event2) { Faker::Internet.unique.domain_word.underscore.to_sym }

        it_behaves_like "callbacks and handler are defined for event" do
          let(:expected_events) { [ event1, event2 ] }
        end

        it_behaves_like "a handler for the callback" do
          before { define_callbacks_with_handler }

          let(:callback) { event1 }
        end

        it_behaves_like "a handler for the callback" do
          before { define_callbacks_with_handler }

          let(:callback) { event2 }
        end
      end
    end

    context "with no options" do
      context "with one event" do
        subject(:define_callbacks_with_handler) { example_class.__send__(:define_callbacks_with_handler, event) }

        let(:event) { Faker::Internet.domain_word.underscore.to_sym }

        it_behaves_like "callbacks and handler are defined for event"
      end

      context "with several events" do
        subject(:define_callbacks_with_handler) { example_class.__send__(:define_callbacks_with_handler, event1, event2) }

        let(:event1) { Faker::Internet.unique.domain_word.underscore.to_sym }
        let(:event2) { Faker::Internet.unique.domain_word.underscore.to_sym }

        it_behaves_like "callbacks and handler are defined for event" do
          let(:expected_events) { [ event1, event2 ] }
        end
      end
    end
  end
end

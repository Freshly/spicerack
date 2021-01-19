# frozen_string_literal: true

# DEP-2021-01-14
# Remove file with deprecation

RSpec.describe Technologic do
  subject(:example_instance) { example_class.new }

  let(:example_class) { Class.new.public_send(:include, described_class) }

  before { stub_const("ExampleClass", example_class) }

  it_behaves_like "a versioned spicerack gem"

  describe "::SEVERITIES" do
    subject { described_class::SEVERITIES }

    it { is_expected.to be_an Array }
  end

  describe "::EXCEPTION_SEVERITIES" do
    subject { described_class::EXCEPTION_SEVERITIES }

    it { is_expected.to be_an Array }
  end

  shared_context "with instrumentation data" do
    let(:event) { Faker::TvShows::GameOfThrones.city.parameterize.underscore }
    let(:data) { Hash[*Faker::Hipster.words(number: rand(1..4) * 2)].symbolize_keys }
    let(:block_value) { Faker::Lorem.word }
    let(:event_namespace) { example_class.name }
    let(:block) do
      ->(_) { block_value }
    end

    before { allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original }
  end

  shared_context "with instrumentation data having a random severity" do
    include_context "with instrumentation data"

    let(:severity) { Technologic::SEVERITIES.sample }
  end

  shared_examples_for "it's instrumented with severity" do
    include_context "with instrumentation data having a random severity"

    subject { ActiveSupport::Notifications }

    it { is_expected.to have_received(:instrument).with("#{event}.#{event_namespace}.#{severity}", **data, &block) }
  end

  describe ".instrument" do
    it_behaves_like "it's instrumented with severity" do
      before { example_class.__send__(:instrument, severity, event, **data, &block) }
    end

    describe "return value" do
      include_context "with instrumentation data having a random severity"

      context "when block returns a value" do
        subject { example_class.__send__(:instrument, severity, event, **data, &block) }

        it { is_expected.to eq block_value }
      end

      context "when block returns nil" do
        subject { example_class.__send__(:instrument, severity, event, **data, &block) }

        let(:block_value) { nil }

        it { is_expected.to eq block_value }
      end

      context "when no block is given" do
        subject { example_class.__send__(:instrument, severity, event, **data) }

        it { is_expected.to eq true }
      end
    end
  end

  shared_examples_for "a severity convenience method" do |described_method|
    it_behaves_like "it's instrumented with severity" do
      before { example_class.public_send(severity, event, **data, &block) }

      let(:severity) { described_method }
    end
  end

  describe ".debug" do
    it_behaves_like "a severity convenience method", :debug
  end

  describe ".info" do
    it_behaves_like "a severity convenience method", :info
  end

  describe ".warn" do
    it_behaves_like "a severity convenience method", :warn
  end

  describe ".error" do
    it_behaves_like "a severity convenience method", :error
  end

  describe ".fatal" do
    it_behaves_like "a severity convenience method", :fatal
  end

  shared_context "with example error class" do
    let(:error_message) { Faker::Lorem.sentence }
    let(:error_module_name) { Faker::Internet.unique.domain_word.underscore.camelize }
    let(:error_class_name) { Faker::Internet.unique.domain_word.underscore.camelize }
    let(:modulized_error_class_name) { "#{error_module_name}::#{error_class_name}" }
    let(:error_class) { modulized_error_class_name.constantize }
    let(:expected_event_name) { "#{error_class_name}.#{event_namespace}.#{severity}" }
    let(:example_error_class) { Class.new(StandardError) }

    before { stub_const(modulized_error_class_name, example_error_class) }
  end

  shared_examples_for "an exception severity method" do |severity|
    include_context "with instrumentation data"

    let(:message) { Faker::Lorem.sentence }
    let(:module_name) { Faker::Internet.unique.domain_word.underscore.camelize }
    let(:error_class_name) { Faker::Internet.unique.domain_word.underscore.camelize }
    let(:modulized_error_class_name) { "#{module_name}::#{error_class_name}" }
    let(:error_class) { modulized_error_class_name.constantize }
    let(:expected_event_name) { "#{error_class_name}.#{event_namespace}.#{severity}" }
    let(:example_error_class) { Class.new(StandardError) }

    before { stub_const(modulized_error_class_name, example_error_class) }

    context "when an exception class is given" do
      subject(:instrument!) { example_class.__send__("#{severity}!", error_class, message, **data, &block) }

      it "raises and logs" do
        expect { instrument! }.to raise_error example_error_class, message

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with(expected_event_name, message: message, **data, &block)
      end
    end

    context "when an exception instance is given" do
      subject(:instrument!) do
        example_class.__send__("#{severity}!", error_instance, **data, &block)
      end

      let(:error_instance) { example_error_class.new(message) }

      it "raises and logs" do
        expect { instrument! }.to raise_error error_instance

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with(expected_event_name, message: message, **data, &block)
      end

      context "when another message is included in the #{severity}! call" do
        subject(:instrument!) do
          example_class.__send__("#{severity}!", error_instance, additional_message, **data, &block)
        end

        let(:additional_message) { Faker::ChuckNorris.fact }

        it "includes the additional message in the log" do
          expect { instrument! }.to raise_error error_instance
          expect(ActiveSupport::Notifications).
            to have_received(:instrument).
            with(expected_event_name, message: message, additional_message: additional_message, **data, &block)
        end
      end
    end
  end

  describe ".error!" do
    it_behaves_like "an exception severity method", :error
  end

  describe ".fatal!" do
    it_behaves_like "an exception severity method", :fatal
  end

  describe ".surveil" do
    include_context "with instrumentation data having a random severity"

    context "when no block is given" do
      subject(:surveil) { example_class.__send__(:surveil, event, severity: severity, **data) }

      it "raises" do
        expect { surveil }.to raise_error LocalJumpError
      end
    end

    context "when a block is given" do
      subject(:surveil) { example_class }

      before do
        allow(example_class).to receive(:instrument)
        example_class.__send__(:surveil, event, severity: severity, **data, &block)
      end

      it { is_expected.to have_received(:instrument).with(severity, "#{event}_started", **data) }
      it { is_expected.to have_received(:instrument).with(severity, "#{event}_finished", &block) }
    end
  end

  shared_examples_for "a class delegated method" do |method|
    include_context "with instrumentation data"

    subject { example_class }

    let(:arguments) { nil }

    before do
      allow(example_class).to receive(method)
      example_instance.__send__(method, event, *arguments, **data, &block)
    end

    it { is_expected.to have_received(method).with(event, *arguments, **data, &block) }
  end

  describe "#debug" do
    it_behaves_like "a class delegated method", :debug
  end

  describe "#info" do
    it_behaves_like "a class delegated method", :info
  end

  describe "#warn" do
    it_behaves_like "a class delegated method", :warn
  end

  describe "#error" do
    it_behaves_like "a class delegated method", :error
  end

  describe "#fatal" do
    it_behaves_like "a class delegated method", :fatal
  end

  shared_examples_for "a class delegated exception method" do |method|
    include_context "with example error class"

    it_behaves_like "a class delegated method", method do
      let(:arguments) { [ example_error_class, error_message ] }
    end
  end

  describe "#error!" do
    it_behaves_like "a class delegated exception method", :error!
  end

  describe "#fatal!" do
    it_behaves_like "a class delegated exception method", :fatal!
  end
end

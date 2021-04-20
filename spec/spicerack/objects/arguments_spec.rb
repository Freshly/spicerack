# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Arguments, type: :module do
  include_context "with an example input object"

  describe ".argument" do
    subject(:define_argument) { example_input_object_class.__send__(:argument, argument, allow_nil: allow_nil, output: output) }

    let(:argument) { Faker::Lorem.word.to_sym }
    let(:argument_value) do
      { allow_nil: allow_nil }
    end
    let(:allow_nil) { true }
    let(:output) { false }

    before { allow(example_input_object_class).to receive(:define_attribute).and_call_original }

    shared_examples_for "an argument is defined" do
      it "adds to _arguments" do
        expect { define_argument }.to change { example_input_object_class._arguments }.from({}).to(argument => argument_value)
      end

      it "defines an attribute" do
        define_argument
        expect(example_input_object_class).to have_received(:define_attribute).with(argument)
      end
    end

    context "with default options" do
      subject(:define_argument) { example_input_object_class.__send__(:argument, argument) }

      it_behaves_like "an argument is defined"
    end

    context "with allow_nil option" do
      context "with allow_nil: true" do
        it_behaves_like "an argument is defined"
      end

      context "with allow_nil: false" do
        let(:allow_nil) { false }

        it_behaves_like "an argument is defined"
      end
    end

    context "with output option" do
      context "when _outputs is defined" do
        before { example_input_object_class.__send__(:class_attribute, :_outputs, instance_writer: false, default: []) }

        context "with output:true" do
          let(:output) { true }

          it "adds to _outputs" do
            expect { define_argument }.to change { example_input_object_class._outputs }.from([]).to([argument])
          end
        end

        context "with output:false" do
          it "does not add to _outputs" do
            expect { define_argument }.to_not change { example_input_object_class._outputs }.from([])
          end
        end
      end

      context "when _outputs is undefined and with output:true" do
        let(:output) { true }

        it "does not raise undefined error" do
          expect { define_argument }.to_not raise_error
        end
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :argument do
      let(:root_class) { example_input_object_class }
      let(:expected_attribute_value) do
        expected_property_value.each_with_object({}) do |argument, hash|
          hash[argument] = { allow_nil: true }
        end
      end
    end
  end

  describe ".after_initialize" do
    before do
      example_input_object_class.__send__(:argument, :test_argument1)
      example_input_object_class.__send__(:argument, :test_argument2)
      example_input_object_class.__send__(:argument, :test_argument3, allow_nil: false)
    end

    context "when required nil arguments are provided" do
      let(:input) do
        { test_argument1: nil, test_argument2: nil, test_argument3: nil }
      end

      it "raises" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing argument: test_argument3"
      end
    end

    context "when nil arguments are provided" do
      let(:input) do
        { test_argument1: nil, test_argument2: nil, test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { example_input_object }.not_to raise_error
      end
    end

    context "when arguments are provided" do
      let(:input) do
        { test_argument1: :test_value1, test_argument2: :test_value2, test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { example_input_object }.not_to raise_error
      end
    end

    context "when one argument is omitted" do
      let(:input) do
        { test_argument1: :test_value1, test_argument3: :test_value3 }
      end

      it "raises" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing argument: test_argument2"
      end
    end

    context "when multiple arguments are omitted" do
      let(:input) do
        { test_argument3: :test_value3 }
      end

      it "does not raise" do
        expect { example_input_object }.to raise_error ArgumentError, "Missing arguments: test_argument1, test_argument2"
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe Substance::Objects::Output, type: :concern do
  include_context "with an example output object"

  describe ".output" do
    it_behaves_like "an input object with a class collection attribute", :output, :_outputs do
      let(:example_input_object_class) { example_output_object_class }
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :output do
      let(:root_class) { example_output_object_class }
    end
  end

  shared_context "with example state having output" do
    let(:example_output_object) { example_class.new }
    let(:example_class) do
      Class.new(example_output_object_class) do
        output :test_output0
        output :test_output1, default: :default_value1
        output(:test_output2) { :default_value2 }
      end
    end

    before do
      stub_const(Faker::Internet.unique.domain_word.underscore.camelize, example_output_object_class)
      stub_const(Faker::Internet.unique.domain_word.underscore.camelize, example_class)
    end
  end

  describe ".after_validation" do
    include_context "with example state having output"

    subject(:valid?) { example_output_object.valid? }

    shared_examples_for "can't read or write output" do
      it "raises on attempted write" do
        expect { example_output_object.test_output0 = :test }.to raise_error Substance::NotValidatedError
        expect { example_output_object.test_output1 = :test }.to raise_error Substance::NotValidatedError
        expect { example_output_object.test_output2 = :test }.to raise_error Substance::NotValidatedError
      end

      it "raises on attempted read" do
        expect { example_output_object.test_output0 }.to raise_error Substance::NotValidatedError
        expect { example_output_object.test_output1 }.to raise_error Substance::NotValidatedError
        expect { example_output_object.test_output2 }.to raise_error Substance::NotValidatedError
      end
    end

    context "without running validations" do
      it_behaves_like "can't read or write output"
    end

    context "with validation errors" do
      before do
        example_class.__send__(:define_attribute, :name)
        example_class.validates :name, presence: true
        valid?
      end

      it_behaves_like "can't read or write output"
    end

    context "without validation errors" do
      it "sets default values" do
        valid?

        expect(example_output_object.test_output1).to eq :default_value1
        expect(example_output_object.test_output2).to eq :default_value2
      end

      it "allows read/write of output" do
        valid?

        expect { example_output_object.test_output0 = :x }.to change { example_output_object.test_output0 }.from(nil).to(:x)
        expect { example_output_object.test_output1 = :y }.to change { example_output_object.test_output1 }.from(:default_value1).to(:y)
        expect { example_output_object.test_output2 = :z }.to change { example_output_object.test_output2 }.from(:default_value2).to(:z)
      end
    end

    context "when run twice after output set" do
      it "allows read/write of output" do
        valid?

        expect { example_output_object.test_output1 = :y }.to change { example_output_object.test_output1 }.from(:default_value1).to(:y)

        # can't use subject cause it's memoized
        expect { example_output_object.valid? }.not_to change { example_output_object.test_output1 }
      end
    end
  end

  describe "#outputs" do
    subject(:outputs) { example_output_object.outputs }

    context "without any outputs" do
      it { is_expected.to eq({}) }
    end

    context "with outputs" do
      include_context "with example state having output"

      context "when not validated" do
        context "when outputs are NOT arguments or options" do
          it "raises" do
            expect { example_output_object.outputs }.to raise_error Substance::NotValidatedError
          end
        end

        context "when outputs are also arguments" do
          let(:example_output_object) { example_class.new(**state_input) }
          let(:state_input) do
            { test_output0: nil, test_output1: :default_value1, test_output2: :default_value2 }
          end

          let(:expected_outputs) { state_input }

          before do
            example_class.__send__(:argument, :test_output0)
            example_class.__send__(:argument, :test_output1)
            example_class.__send__(:argument, :test_output2)
          end

          it { is_expected.to have_attributes(**expected_outputs) }
        end

        context "when outputs are also options" do
          let(:expected_outputs) do
            { test_output0: :option_default_value0, test_output1: :option_default_value1, test_output2: nil }
          end

          before do
            example_class.__send__(:option, :test_output0, default: :option_default_value0)
            example_class.__send__(:option, :test_output1, default: :option_default_value1)
            example_class.__send__(:option, :test_output2)
          end

          it { is_expected.to have_attributes(**expected_outputs) }
        end
      end

      context "when validated" do
        let(:expected_outputs) do
          { test_output0: nil, test_output1: :default_value1, test_output2: :default_value2 }
        end

        before { example_output_object.valid? }

        it { is_expected.to have_attributes(**expected_outputs) }
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe Tablesalt::StringableObject, type: :concern do
  let(:sample_class) do
    Struct.new(*attribute_names).instance_exec(described_class) do |described_class|
      include described_class
    end
  end
  let(:sample_class_name) { Faker::Lorem.words(4).join("_").camelize }

  let(:all_attributes) { Hash[*Faker::Lorem.words(rand(1..3) * 2)].symbolize_keys }
  let(:attribute_names) { all_attributes.keys }
  let(:stringable_object) { sample_class.new(*all_attributes.values) }

  before do
    stub_const(sample_class_name, sample_class)
  end

  context "when to_s is called with no arguments" do
    subject(:stringified_object) { stringable_object.to_s }

    context "when stringable_data_keys is not defined" do
      it "raises an error" do
        expect { stringified_object }.to raise_error NameError
      end
    end

    context "when stringable_data_keys is defined" do
      let(:data_keys) { [] }

      before do
        sample_class.instance_exec(self) do |spec_context|
          define_method :stringable_data_keys do
            spec_context.data_keys
          end
          private :stringable_data_keys
        end
      end

      context "when no stringable_data_keys are specified" do
        let(:expected_string) { "#<#{sample_class_name} >" }

        it { is_expected.to eq expected_string }
      end

      context "when some stringable_data_keys are specified" do
        let(:data_keys) { attribute_names.sample(rand(1..attribute_names.size)) }
        let(:data_strings) { data_keys.map { |name| "#{name}: #{all_attributes[name]}" }.join(", ") }
        let(:expected_string) { "#<#{sample_class_name} #{data_strings}>" }

        it { is_expected.to eq expected_string }
      end
    end
  end

  context "when to_s is called with :pretty as an argument" do
    it "returns the pretty string"
  end
end

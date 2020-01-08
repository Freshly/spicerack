# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Attributes, type: :module do
  include_context "with an example input object"

  shared_context "with attributes defined on the class" do
    let(:attributes) { Faker::Lorem.words(rand(2..5)).map(&:to_sym) }

    before do
      example_input_object_class.instance_exec(self) do |spec_context|
        spec_context.attributes.each do |attr|
          define_attribute attr
        end
      end
    end
  end

  describe ".define_attribute" do
    subject(:define_attribute) { example_input_object_class.__send__(:define_attribute, attribute) }

    let(:attribute) { Faker::Lorem.word.to_sym }

    it "adds to _attributes" do
      expect { define_attribute }.to change { example_input_object_class._attributes }.from([]).to([ attribute ])
    end

    describe "accessors" do
      subject { example_input_object_class }

      before { define_attribute }

      it { is_expected.to be_public_method_defined attribute }
      it { is_expected.to be_public_method_defined "#{attribute}=" }
    end
  end

  describe ".attribute" do
    subject { example_input_object_class }

    it { is_expected.to alias_method :attribute, :define_attribute }
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :define_attribute, :_attributes do
      let(:root_class) { example_input_object_class }
    end
  end

  describe "#to_h" do
    subject { example_input_object.to_h }

    include_context "with attributes defined on the class"

    let(:values) { Faker::Hipster.words(attributes.length) }
    let(:input) { attributes.zip(values).to_h }

    it { is_expected.to eq input }

    context "when contain a nested input object" do
      let(:nested_input_object) { example_input_object_class.new(**nested_input) }
      let(:nested_values) { values.map(&:reverse) }
      let(:nested_input) { attributes.zip(nested_values).to_h }

      before { input[attributes.sample] = nested_input_object }

      it { is_expected.to eq input }
    end
  end

  describe "#stringable_attributes" do
    subject { example_input_object.__send__(:stringable_attributes) }

    include_context "with attributes defined on the class"

    it { is_expected.to eq attributes }
  end
end

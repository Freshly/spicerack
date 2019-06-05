# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::Reader do
  subject(:reader) { described_class.new(config) }

  let(:config_class) { Class.new(Spicerack::InputObject) }
  let(:config) { config_class.new }

  let(:config_attributes) { Faker::Lorem.words(3).map(&:to_sym) }
  let(:attribute_with_default) { config_attributes.sample }
  let(:attributes_without_default) { config_attributes.without(attribute_with_default) }
  let(:default_value) { Faker::Hipster.sentence }

  before do
    config_class.instance_exec(self) do |spec_context|
      spec_context.attributes_without_default.each do |attr|
        option attr
      end

      option spec_context.attribute_with_default, default: spec_context.default_value
    end
  end

  describe "#config" do
    it "privately returns an InputObject" do
      expect(reader.private_methods).to include :config
      expect(reader.__send__(:config)).to eq config
    end
  end

  describe "#method_missing" do
    let(:config_values) { [ config_attributes.map(&:to_sym), Array.new(3) { double } ].transpose.to_h }
    let(:config) { config_class.new(**config_values) }

    it "responds to attr_readers from config" do
      config_attributes.each do |attr|
        expect(reader.public_send(attr)).to eq config.public_send(attr)
      end
    end

    it "doesn't respond to attr_writers from config" do
      config_attributes.each do |attr|
        expect { reader.public_send("#{attr}=", double) }.to raise_error NoMethodError
      end
    end
  end
end
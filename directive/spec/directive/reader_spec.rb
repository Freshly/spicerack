# frozen_string_literal: true

RSpec.describe Directive::Reader do
  subject(:reader) { described_class.new(config) }

  let(:config_class) { Class.new(Directive::ConfigObject) }
  let(:config) { config_class.instance }

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

    before do
      config_values.each { |key, value| config.public_send("#{key}=", value) }
    end

    it "responds to attr_readers from config" do
      config_attributes.each do |attr|
        expect(reader).to respond_to attr
        expect(reader.public_send(attr)).to eq config.public_send(attr)
      end
    end

    it "doesn't respond to attr_writers from config" do
      config_attributes.each do |attr|
        expect(reader).not_to respond_to "#{attr}="
        expect { reader.public_send("#{attr}=", double) }.to raise_error NoMethodError
      end
    end

    context "when a nested config is defined" do
      let(:nested_parent) { Faker::Superhero.name.parameterize.underscore.to_sym }
      let(:nested_option) { Faker::Lorem.word.to_sym }
      let(:nested_default_value) { Faker::Lorem.sentence }
      let(:nested_reader) { reader.public_send(nested_parent) }

      before do
        config_class.instance_exec(self) do |spec_context|
          nested spec_context.nested_parent do
            option spec_context.nested_option, default: spec_context.nested_default_value
          end
        end
      end

      it { is_expected.to respond_to(nested_parent) }

      it "returns a nested reader" do
        expect(nested_reader).to be_a described_class
      end

      it "responds to nested attr_readers" do
        expect(nested_reader.public_send(nested_option)).to eq nested_default_value
      end

      it "doesn't respond to nested writer methods" do
        expect { nested_reader.public_send("#{nested_option}=") }.to raise_error NoMethodError
      end
    end
  end
end

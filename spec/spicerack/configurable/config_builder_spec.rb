# frozen_string_literal: true

RSpec.describe Spicerack::Configurable::ConfigBuilder do
  subject(:builder) { described_class.new }

  let(:all_options) { Faker::Lorem.words(4).map(&:to_sym) }
  let(:options_with_defaults) { all_options.sample(2) }
  let(:options_without_defaults) { all_options - options_with_defaults }
  let(:default_values) do
    options_with_defaults.each_with_object({}) { |opt, hash| hash[opt] = Faker::Hipster.word }
  end

  before do
    options_without_defaults.each { |opt| builder.option opt }
    default_values.each { |opt, default| builder.option opt, default: default }
  end

  describe "#reader" do
    subject(:reader) { builder.reader }

    it { is_expected.to be_a Spicerack::Configurable::Reader }
    it "returns all config values" do
      options_without_defaults.each do |opt|
        expect(reader.public_send(opt)).to eq nil
      end

      default_values.each do |opt, value|
        expect(reader.public_send(opt)).to eq value
      end
    end
  end

  describe "#configure" do
    shared_examples_for "it is frozen and duped" do
      it { is_expected.to be_frozen }
      it { is_expected.to eq custom_value }
      it { is_expected.not_to equal custom_value }
    end

    it "yields the input object" do
      builder.configure do |config|
        expect(config).to be_a Spicerack::InputObject

        all_options.each do |opt|
          expect(config).to define_option opt, default: default_values[opt]
        end
      end
    end

    context "when default values are set" do
      subject(:config_value) { builder.reader.public_send(custom_attr) }

      before { builder.configure {} }

      let(:custom_attr) { options_with_defaults.sample }
      let(:custom_value) { default_values[custom_attr] }

      it_behaves_like "it is frozen and duped"
    end

    context "when custom values are set" do
      subject(:config_value) { builder.reader.public_send(custom_attr) }

      let(:custom_attr) { all_options.sample }
      let(:custom_value) { Faker::Lorem.sentence }

      before do
        builder.configure { |config| config.public_send("#{custom_attr}=", custom_value) }
      end

      shared_examples_for "it is frozen and duped" do
        it { is_expected.to be_frozen }
        it { is_expected.to eq custom_value }
        it { is_expected.not_to equal custom_value }
      end

      it_behaves_like "it is frozen and duped"

      context "when custom value is an array" do
        let(:custom_value) { Faker::Lorem.words(5) }

        it_behaves_like "it is frozen and duped"
        it { is_expected.to all be_frozen }

        it "dups each element" do
          config_value.each_with_index do |item, i|
            expect(item).to eq custom_value[i]
            expect(item).not_to equal custom_value[i]
          end
        end
      end

      context "when custom value is a hash" do
        let(:custom_value) { Hash[Faker::Lorem.words(6)] }

        it_behaves_like "it is frozen and duped"

        it "dups each value" do
          config_value.each do |key, value|
            expect(value).to eq custom_value[key]
            expect(value).not_to equal custom_value[key]
          end
        end
      end
    end
  end

  describe "#option" do
    let(:additional_option) { Faker::Superhero.name.parameterize.underscore.to_sym }
    let(:additional_default_value) { Faker::Lorem.sentence }

    before { builder.option(additional_option, default: additional_default_value) }

    it "adds the additional option" do
      builder.configure do |config|
        expect(config).to define_option(additional_option, default: additional_default_value)
      end
    end
  end
end

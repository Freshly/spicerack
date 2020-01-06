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

  describe "Callbacks" do
    describe "configure" do
      subject { described_class.__callbacks[:configure] }

      it { is_expected.to be_a ActiveSupport::Callbacks::CallbackChain }
    end
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
    it "yields the input object" do
      builder.configure do |config|
        expect(config).to be_a Spicerack::InputObject

        all_options.each do |opt|
          expect(config).to define_option opt, default: default_values[opt]
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

  describe "#nested" do
    let(:nested_parent) { Faker::Superhero.name.parameterize.underscore.to_sym }
    let(:nested_options) { Faker::Lorem.words(5).map(&:to_sym).uniq }
    let!(:nested_option) { nested_options.pop }
    let!(:nested_option_with_default) { nested_options.pop }
    let(:nested_default_value) { Faker::Hipster.sentence }

    before do
      builder.instance_exec(self) do |spec_context|
        nested(spec_context.nested_parent) do
          option spec_context.nested_option
          option spec_context.nested_option_with_default, default: spec_context.nested_default_value
        end
      end
    end

    it "defines a nested ConfigObject" do
      builder.configure do |config|
        nested_config = config.public_send(nested_parent)

        expect(nested_config).to be_a Spicerack::Configurable::ConfigObject
        expect(nested_config).to define_option nested_option
        expect(nested_config).to define_option(nested_option_with_default, default: nested_default_value)
      end
    end
  end
end

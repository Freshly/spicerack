# frozen_string_literal: true

RSpec.describe Directive, type: :configuration do
  subject(:configurable) { example_configurable }

  let(:has_default_default_value) { "A default value" }
  let(:example_configurable) { Module.new }

  before do
    example_configurable.instance_exec(self) do |spec_context|
      extend spec_context.described_class

      configuration_options do
        option :no_default
        option :has_default, default: spec_context.has_default_default_value
      end
    end
  end

  it { is_expected.to define_config_option :no_default }

  describe ".configure" do
    it "defines options" do
      example_configurable.configure do |config|
        expect(config).to define_option :no_default
        expect(config).to define_option :has_default, default: has_default_default_value
      end
    end
  end

  describe ".config" do
    context "when values are set" do
      let(:has_default_value) { Faker::Lorem.word }
      let(:no_default_value) { Faker::Lorem.word }

      before do
        example_configurable.configure do |config|
          config.no_default = no_default_value
          config.has_default = has_default_value
        end
      end

      it "sets the config variables" do
        expect(example_configurable.config.no_default).to eq no_default_value
        expect(example_configurable.config.has_default).to eq has_default_value
      end
    end

    context "when no values are set" do
      it "has the default values, or nil" do
        expect(example_configurable.config.no_default).to eq nil
        expect(example_configurable.config.has_default).to eq has_default_default_value
      end
    end
  end

  describe ".before_configure" do
    let(:callback_proc) { -> {} }
    let(:last_callback) do
      example_configurable.__send__(:_config_builder_class).__callbacks[:configure].__send__(:chain).last
    end

    before { example_configurable.before_configure(&callback_proc) }

    it "sets up a callback" do
      expect(last_callback.kind).to eq :before
      expect(last_callback.instance_values["filter"]).to eq callback_proc
    end
  end

  describe ".after_configure" do
    let(:callback_proc) { -> {} }
    let(:last_callback) do
      example_configurable.__send__(:_config_builder_class).__callbacks[:configure].__send__(:chain).last
    end

    before { example_configurable.after_configure(&callback_proc) }

    it "sets up a callback" do
      expect(last_callback.kind).to eq :after
      expect(last_callback.instance_values["filter"]).to eq callback_proc
    end
  end

  describe "writers" do
    it "doesn't set writers for the config options" do
      expect { example_configurable.configuration.no_default = Faker::Lorem.word }.to raise_error(NoMethodError)
      expect { example_configurable.configuration.has_default = Faker::Lorem.word }.to raise_error(NoMethodError)
    end
  end
end

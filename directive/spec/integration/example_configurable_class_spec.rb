# frozen_string_literal: true

module ExampleConfigurableClass; end

RSpec.describe ExampleConfigurableClass, type: :configuration do
  subject(:configurable_module) do
    Module.new do
      extend Directive

      configuration_options do
        option :option_without_default
        option :option_with_default, default: "default value"
        option(:option_with_default_block) { "default value from block" }

        option :option_without_default_to_assign
        option :option_with_default_to_assign, default: "default value to assign"
        option(:option_with_default_block_to_assign) { "default value from block to assign" }

        nested :nested_config do
          option :nested_option_without_default
          option :nested_option_with_default, default: "nested default value"
          option(:nested_option_with_default_block) { "nested default value from block" }

          option :nested_option_without_default_to_assign
          option :nested_option_with_default_to_assign, default: "nested default value to assign"
          option(:nested_option_with_default_block_to_assign) { "nested default value from block to assign" }

          option :nested_option_without_default_override_in_nested_block
          option :nested_option_with_default_override_in_nested_block, default: "nested option with default override in nested block"
          option(:nested_option_with_default_block_override_in_nested_block) { "nested option with default block override in nested block" }

          nested :double_nested do
            option :double_nested_option_without_default
            option :double_nested_option_with_default, default: "double nested default value"
            option(:double_nested_option_with_default_block) { "double nested default value from block" }

            option :double_nested_option_without_default_override_in_nested_block
            option :double_nested_option_with_default_override_in_nested_block, default: "double nested option with default override in nested block"
            option(:double_nested_option_with_default_block_override_in_nested_block) { "double nested option with default block override in nested block" }
          end
        end
      end
    end
  end

  let(:described_class) { configurable_module }
  let(:config) { configurable_module.config }

  let(:called_from_before_callback) { double(called_inside_callback: true) }
  let(:called_from_after_callback) { double(called_inside_callback: true) }

  before do
    allow(called_from_before_callback).to receive(:called_inside_callback)
    allow(called_from_after_callback).to receive(:called_inside_callback)

    configurable_module.instance_exec(self) do |spec_context|
      before_configure do
        spec_context.called_from_before_callback.called_inside_callback
      end

      after_configure do
        spec_context.called_from_after_callback.called_inside_callback
      end
    end
  end

  it { is_expected.to define_config_option(:option_without_default) }
  it { is_expected.to define_config_option(:option_with_default, default: "default value") }
  it { is_expected.to define_config_option(:option_with_default_block, default: "default value from block") }

  it { is_expected.to define_config_option(:option_without_default_to_assign) }
  it { is_expected.to define_config_option(:option_with_default_to_assign, default: "default value to assign") }
  it { is_expected.to define_config_option(:option_with_default_block_to_assign, default: "default value from block to assign") }

  nested_config_option :nested_config do
    it { is_expected.to define_config_option(:nested_option_without_default) }
    it { is_expected.to define_config_option(:nested_option_with_default, default: "nested default value") }
    it { is_expected.to define_config_option(:nested_option_with_default_block, default: "nested default value from block") }

    it { is_expected.to define_config_option(:nested_option_without_default_to_assign) }
    it { is_expected.to define_config_option(:nested_option_with_default_to_assign, default: "nested default value to assign") }
    it { is_expected.to define_config_option(:nested_option_with_default_block_to_assign, default: "nested default value from block to assign") }

    it { is_expected.to define_config_option(:nested_option_without_default_override_in_nested_block) }
    it { is_expected.to define_config_option(:nested_option_with_default_override_in_nested_block, default: "nested option with default override in nested block") }
    it { is_expected.to define_config_option(:nested_option_with_default_block_override_in_nested_block, default: "nested option with default block override in nested block" ) }

    nested_config_option :double_nested do
      it { is_expected.to define_config_option(:double_nested_option_without_default) }
      it { is_expected.to define_config_option(:double_nested_option_with_default, default: "double nested default value") }
      it { is_expected.to define_config_option(:double_nested_option_with_default_block, default: "double nested default value from block") }

      it { is_expected.to define_config_option(:double_nested_option_without_default_override_in_nested_block) }
      it { is_expected.to define_config_option(:double_nested_option_with_default_override_in_nested_block, default: "double nested option with default override in nested block") }
      it { is_expected.to define_config_option(:double_nested_option_with_default_block_override_in_nested_block, default: "double nested option with default block override in nested block" ) }
    end
  end

  describe "config writers" do
    describe "root config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.option_without_default = double }.to raise_error NoMethodError
        expect { config.option_with_default = double }.to raise_error NoMethodError
        expect { config.option_with_default_block = double }.to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.assign }.to raise_error NoMethodError
        expect { config.assign_attributes }.to raise_error NoMethodError
      end
    end

    describe "nested config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.nested_config.nested_option_without_default = double }.to raise_error NoMethodError
        expect { config.nested_config.nested_option_with_default = double }.to raise_error NoMethodError
        expect { config.nested_config.nested_option_with_default_block = double }.to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.nested_config.assign }.to raise_error NoMethodError
        expect { config.nested_config.assign_attributes }.to raise_error NoMethodError
      end
    end

    describe "deeply nested config vars" do
      it "doesn't define accessors outside of configure block" do
        expect { config.nested_config.double_nested.double_nested_option_without_default = double }.
          to raise_error NoMethodError
        expect { config.nested_config.double_nested.double_nested_option_with_default = double }.
          to raise_error NoMethodError
        expect { config.nested_config.double_nested.double_nested_option_with_default_block = double }.
          to raise_error NoMethodError
      end

      it "doesn't define attribute assignment methods" do
        expect { config.nested_config.double_nested.assign }.to raise_error NoMethodError
        expect { config.nested_config.double_nested.assign_attributes }.to raise_error NoMethodError
      end
    end
  end

  context "when runtime configuration has not been set up" do
    describe "root config vars" do
      it "uses the default values" do
        expect(config.option_without_default).to be_nil
        expect(config.option_with_default).to eq "default value"
        expect(config.option_with_default_block).to eq "default value from block"

        expect(configurable_module.config_eval(:option_without_default).read).to be_nil
        expect(configurable_module.config_eval(:option_with_default).read).to eq "default value"
        expect(configurable_module.config_eval(:option_with_default_block).read).to eq "default value from block"
      end
    end

    describe "nested config vars" do
      it "uses the default values" do
        expect(config.nested_config.nested_option_without_default).to be_nil
        expect(config.nested_config.nested_option_with_default).to eq "nested default value"
        expect(config.nested_config.nested_option_with_default_block).to eq "nested default value from block"

        expect(configurable_module.config_eval(:nested_config, :nested_option_without_default).read).
          to be_nil
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default).read).
          to eq "nested default value"
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default_block).read).
          to eq "nested default value from block"
      end
    end

    describe "deeply nested config vars" do
      it "uses the default values" do
        expect(config.nested_config.double_nested.double_nested_option_without_default).to be_nil
        expect(config.nested_config.double_nested.double_nested_option_with_default).
          to eq "double nested default value"
        expect(config.nested_config.double_nested.double_nested_option_with_default_block).
          to eq "double nested default value from block"
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_without_default).read).
          to be_nil
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default).read).
          to eq "double nested default value"
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default_block).read).
          to eq "double nested default value from block"
      end
    end

    it "does not call callbacks" do
      expect(called_from_before_callback).not_to have_received(:called_inside_callback)
      expect(called_from_after_callback).not_to have_received(:called_inside_callback)
    end
  end

  context "when runtime configuration has been set up" do
    let(:option_without_default_override) { "option without default override" }
    let(:option_with_default_override) { "option with default override" }
    let(:option_with_default_block_override) { "option with default block override" }

    let(:nested_option_without_default_override) { "nested option without default override" }
    let(:nested_option_with_default_override) { "nested option with default override" }
    let(:nested_option_with_default_block_override) { "nested option with default block override" }

    let(:double_nested_option_without_default_override) { "double nested option without default override" }
    let(:double_nested_option_with_default_override) { "double nested option with default override" }
    let(:double_nested_option_with_default_block_override) { "double nested option with default block override" }

    let(:option_without_default_override_to_assign) { "option without default override on assign" }
    let(:option_with_default_override_to_assign) { "option with default override on assign" }
    let(:option_with_default_block_override_to_assign) { "option with default block override on assign" }

    let(:nested_option_without_default_override_to_assign) { SecureRandom.hex }
    let(:nested_option_with_default_override_to_assign) { SecureRandom.hex }
    let(:nested_option_with_default_block_override_to_assign) { SecureRandom.hex }

    let(:override_nested_option_without_default_override_in_nested_block) { SecureRandom.hex }
    let(:override_nested_option_with_default_override_in_nested_block) { SecureRandom.hex }
    let(:override_nested_option_with_default_block_override_in_nested_block) { SecureRandom.hex }

    let(:override_double_nested_option_without_default_override_in_nested_block) { SecureRandom.hex }
    let(:override_double_nested_option_with_default_override_in_nested_block) { SecureRandom.hex }
    let(:override_double_nested_option_with_default_block_override_in_nested_block) { SecureRandom.hex }

    before do
      configurable_module.configure do |konfig|
        konfig.option_without_default = option_without_default_override
        konfig.option_with_default = option_with_default_override
        konfig.option_with_default_block = option_with_default_block_override

        konfig.nested_config.nested_option_without_default = nested_option_without_default_override
        konfig.nested_config.nested_option_with_default = nested_option_with_default_override
        konfig.nested_config.nested_option_with_default_block = nested_option_with_default_block_override

        konfig.nested_config.double_nested.double_nested_option_without_default = double_nested_option_without_default_override
        konfig.nested_config.double_nested.double_nested_option_with_default = double_nested_option_with_default_override
        konfig.nested_config.double_nested.double_nested_option_with_default_block = double_nested_option_with_default_block_override

        konfig.assign(
          option_without_default_to_assign: option_without_default_override_to_assign,
          option_with_default_to_assign: option_with_default_override_to_assign,
          option_with_default_block_to_assign: option_with_default_block_override_to_assign,
        )

        konfig.nested_config.assign(
          nested_option_without_default_to_assign: nested_option_without_default_override_to_assign,
          nested_option_with_default_to_assign: nested_option_with_default_override_to_assign,
          nested_option_with_default_block_to_assign: nested_option_with_default_block_override_to_assign,
        )

        konfig.nested_config do |nested|
          nested.nested_option_without_default_override_in_nested_block = override_nested_option_without_default_override_in_nested_block
          nested.nested_option_with_default_override_in_nested_block = override_nested_option_with_default_override_in_nested_block
          nested.nested_option_with_default_block_override_in_nested_block = override_nested_option_with_default_block_override_in_nested_block

          nested.double_nested do |double_nested|
            double_nested.double_nested_option_without_default_override_in_nested_block = override_double_nested_option_without_default_override_in_nested_block
            double_nested.double_nested_option_with_default_override_in_nested_block = override_double_nested_option_with_default_override_in_nested_block
            double_nested.double_nested_option_with_default_block_override_in_nested_block = override_double_nested_option_with_default_block_override_in_nested_block
          end
        end
      end
    end

    describe "root config vars" do
      it "sets the override values" do
        expect(configurable_module.config.option_without_default).to eq option_without_default_override
        expect(configurable_module.config.option_with_default).to eq option_with_default_override
        expect(configurable_module.config.option_with_default_block).to eq option_with_default_block_override
      end

      it "sets the override values with assign" do
        expect(configurable_module.config.option_without_default_to_assign).to eq option_without_default_override_to_assign
        expect(configurable_module.config.option_with_default_to_assign).to eq option_with_default_override_to_assign
        expect(configurable_module.config.option_with_default_block_to_assign).to eq option_with_default_block_override_to_assign
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:option_without_default).read).to eq option_without_default_override
        expect(configurable_module.config_eval(:option_with_default).read).to eq option_with_default_override
        expect(configurable_module.config_eval(:option_with_default_block).read).to eq option_with_default_block_override
      end
    end

    describe "nested config vars" do
      it "sets the override values" do
        expect(configurable_module.config.nested_config.nested_option_without_default).
          to eq nested_option_without_default_override
        expect(configurable_module.config.nested_config.nested_option_with_default).
          to eq nested_option_with_default_override
        expect(configurable_module.config.nested_config.nested_option_with_default_block).
          to eq nested_option_with_default_block_override
      end

      it "sets the override values with assign" do
        expect(configurable_module.config.nested_config.nested_option_without_default_to_assign).
          to eq nested_option_without_default_override_to_assign
        expect(configurable_module.config.nested_config.nested_option_with_default_to_assign).
          to eq nested_option_with_default_override_to_assign
        expect(configurable_module.config.nested_config.nested_option_with_default_block_to_assign).
          to eq nested_option_with_default_block_override_to_assign
      end

      it "sets the override values with doubly nested block" do
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_without_default_override_in_nested_block).
          to eq override_double_nested_option_without_default_override_in_nested_block
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default_override_in_nested_block).
          to eq override_double_nested_option_with_default_override_in_nested_block
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default_block_override_in_nested_block).
          to eq override_double_nested_option_with_default_block_override_in_nested_block
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :nested_option_without_default).read).
          to eq nested_option_without_default_override
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default).read).
          to eq nested_option_with_default_override
        expect(configurable_module.config_eval(:nested_config, :nested_option_with_default_block).read).
          to eq nested_option_with_default_block_override
      end
    end

    describe "deeply nested config vars" do
      it "sets the override values" do
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_without_default).
          to eq double_nested_option_without_default_override
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default).
          to eq double_nested_option_with_default_override
        expect(configurable_module.config.nested_config.double_nested.double_nested_option_with_default_block).
          to eq double_nested_option_with_default_block_override
      end

      it "is accessible via evaluators" do
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_without_default).read).
          to eq double_nested_option_without_default_override
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default).read).
          to eq double_nested_option_with_default_override
        expect(configurable_module.config_eval(:nested_config, :double_nested, :double_nested_option_with_default_block).read).
          to eq double_nested_option_with_default_block_override
      end
    end

    it "calls callbacks" do
      expect(called_from_before_callback).to have_received(:called_inside_callback)
      expect(called_from_after_callback).to have_received(:called_inside_callback)
    end
  end

  describe "ConfigDelegation" do
    let(:delegating_configurable_class) do
      Class.new do
        include Directive::ConfigDelegation
      end
    end
    let(:delegating_class_name) { Faker::Lorem.sentence.titleize.delete(" .") }
    let(:configurable_module_name) { "Configuration" }

    before do
      stub_const(delegating_class_name, delegating_configurable_class)
      stub_const("#{delegating_class_name}::#{configurable_module_name}", configurable_module)
    end

    shared_examples_for "it delegates to the configurable module" do
      before { allow(configurable_module).to receive(:configure).and_call_original }

      it "delegates to the Configuration module" do
        expect(delegating_configurable_class.config).to eq configurable_module.config

        delegating_configurable_class.configure do |config|
          expect(config).to eq configurable_module.config.__send__(:config)
        end
      end
    end

    context "when the configuration module is named Configuration" do
      context "when the confiration module is not provided" do
        before do
          delegating_configurable_class.instance_exec { delegates_to_configuration }
        end

        it_behaves_like "it delegates to the configurable module"
      end

      context "when the confiration module is provided" do
        before do
          delegating_configurable_class.instance_exec(self) do |spec_context|
            delegates_to_configuration spec_context.configurable_module
          end
        end

        it_behaves_like "it delegates to the configurable module"
      end
    end

    context "when the configuration module is not named Configuration" do
      let(:configurable_module_name) { Faker::Lorem.sentence.titleize.delete(" .") }

      context "when the confiration module is not provided" do
        it "raises" do
          expect { delegating_configurable_class.instance_exec { delegates_to_configuration } }.
            to raise_error NameError, "uninitialized constant #{delegating_configurable_class}::Configuration"
        end
      end

      context "when the confiration module is provided" do
        before do
          delegating_configurable_class.instance_exec(self) do |spec_context|
            delegates_to_configuration spec_context.configurable_module
          end
        end

        it_behaves_like "it delegates to the configurable module"
      end
    end

    context "when config delegation is not set up" do
      it "raises" do
        expect { delegating_configurable_class.config }.
          to raise_error NoMethodError, "Configuration not set up for #{delegating_configurable_class}. Did you forget to call delegates_to_configuration?"
        expect { delegating_configurable_class.configure }.
          to raise_error NoMethodError, "Configuration not set up for #{delegating_configurable_class}. Did you forget to call delegates_to_configuration?"
      end
    end
  end
end

# frozen_string_literal: true

RSpec.describe Directive::ConfigDelegation do
  let(:configurable_class_name) { Faker::Lorem.sentence.parameterize.underscore.camelize }
  let(:inferred_configuration_module_name) { "Configuration" }
  let(:explicit_configuration_module_name) { Faker::Lorem.sentence.parameterize.underscore.camelize }

  let(:configurable_class) do
    Class.new.tap do |klass|
      klass.instance_exec(self) do |spec_context|
        include spec_context.described_class
      end
    end
  end
  let(:inferred_configuration_module) do
    Module.new do
      extend Directive
    end
  end
  let(:explicit_configuration_module) do
    Module.new do
      extend Directive
    end
  end

  let(:inferred_name_config) { double }
  let(:inferred_name_configuration) { class_double(Directive) }

  let(:explicit_name_config) { double }
  let(:explicit_name_configuration) { class_double(Directive) }

  before do
    stub_const(configurable_class_name, configurable_class)
    stub_const("#{configurable_class_name}::#{inferred_configuration_module_name}", inferred_configuration_module)
    stub_const("#{configurable_class_name}::#{explicit_configuration_module_name}", explicit_configuration_module)

    allow(inferred_configuration_module).to receive(:config).and_return(inferred_name_config)
    allow(inferred_configuration_module).to receive(:configure).and_yield(inferred_name_configuration)

    allow(explicit_configuration_module).to receive(:config).and_return(explicit_name_config)
    allow(explicit_configuration_module).to receive(:configure).and_yield(explicit_name_configuration)
  end

  shared_context "when delegates_to_configuration is called without a module" do
    before do
      configurable_class.instance_exec do
        delegates_to_configuration
      end
    end
  end

  shared_context "when delegates_to_configuration is called with an explicit module" do
    before do
      configurable_class.instance_exec(self) do |spec_context|
        delegates_to_configuration spec_context.explicit_configuration_module
      end
    end
  end

  shared_examples_for "it delegates configuration methods" do
    it "delegates configuration methods to the configurable module" do
      expect(configurable_class).to delegate_config_to expected_configurable_module
    end
  end

  shared_examples_for "it does not delegate configuration methods" do
    it "does not delegate configuration methods to the configurable module" do
      expect(configurable_class).not_to delegate_config_to expected_configurable_module
    end
  end

  describe "#config" do
    subject(:konfig) { configurable_class.config }

    context "when delegates_to_configuration is called without a module" do
      include_context "when delegates_to_configuration is called without a module"

      it { is_expected.to eq inferred_name_config }

      it_behaves_like "it delegates configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end
    end

    context "when delegates_to_configuration is called with an explicit module" do
      include_context "when delegates_to_configuration is called with an explicit module"

      it { is_expected.to eq explicit_name_config }

      it_behaves_like "it delegates configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end
    end

    context "when delegates_to_configuration is not called" do
      it "raises" do
        expect { konfig }.to raise_error NoMethodError
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end
    end
  end

  describe "#configure" do
    context "when delegates_to_configuration is called without a module" do
      include_context "when delegates_to_configuration is called without a module"

      it "yields to the configuration module" do
        configurable_class.configure do |konfig|
          expect(konfig).to eq inferred_name_configuration
        end
      end

      it_behaves_like "it delegates configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end
    end

    context "when delegates_to_configuration is called with an explicit module" do
      include_context "when delegates_to_configuration is called with an explicit module"

      it "yields to the configuration module" do
        configurable_class.configure do |konfig|
          expect(konfig).to eq explicit_name_configuration
        end
      end

      it_behaves_like "it delegates configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end


      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end
    end

    context "when delegates_to_configuration is not called" do
      it "raises" do
        expect { configurable_class.configure }.to raise_error NoMethodError
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { inferred_configuration_module }
      end

      it_behaves_like "it does not delegate configuration methods" do
        let(:expected_configurable_module) { explicit_configuration_module }
      end
    end
  end
end

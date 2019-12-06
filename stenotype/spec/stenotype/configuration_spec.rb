# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Configuration, type: :configuration do
  subject(:configuration) { described_class }

  describe ".targets" do
    subject(:targets) { configuration.targets }

    context "when a target(s) have been specified" do
      let(:test_target) { Stenotype::TestAdapter.new }

      before { Stenotype.configure { |config| config.targets = [ test_target ] } }

      it { is_expected.to match_array([ test_target ]) }
    end

    context "when no targets have been specified" do
      before { Stenotype.configure { |config| config.targets = [] } }

      it "raises" do
        expect { targets }.to raise_error(Stenotype::NoTargetsSpecifiedError)
      end
    end
  end

  it { is_expected.to define_config_option :targets, default: [] }
  it { is_expected.to define_config_option :dispatcher, default: Stenotype::Dispatcher }
  it { is_expected.to define_config_option :uuid_generator, default: SecureRandom }

  nested_config_option :rails do
    it { is_expected.to define_config_option(:enable_action_controller_ext, default: true) }
    it { is_expected.to define_config_option(:enable_active_job_ext, default: true) }
  end

  nested_config_option :google_cloud do
    it { is_expected.to define_config_option :credentials, default: nil }
    it { is_expected.to define_config_option :project_id, default: nil }
    it { is_expected.to define_config_option :topic, default: nil }
    it { is_expected.to define_config_option :async, default: true }
  end
end

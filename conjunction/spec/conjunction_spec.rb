# frozen_string_literal: true

RSpec.describe Conjunction do
  it_behaves_like "a versioned spicerack gem"

  it { is_expected.to include_module Directive::ConfigDelegation }

  describe "._configuration_module" do
    subject { described_class.__send__(:_configuration_module) }

    it { is_expected.to eq Conjunction::Configuration }
  end

  describe described_class::Error do
    it { is_expected.to inherit_from StandardError }
  end

  describe described_class::DisjointedError do
    it { is_expected.to inherit_from Conjunction::Error }
  end
end

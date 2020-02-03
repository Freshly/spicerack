# frozen_string_literal: true

RSpec.describe Conjunction::Configuration, type: :configuration do
  subject { described_class }

  it { is_expected.to extend_module Directive }

  it { is_expected.to define_config_option(:nexus_use_disables_implicit_lookup, default: false) }
  it { is_expected.to define_config_option(:disable_all_implicit_lookup, default: false) }
end

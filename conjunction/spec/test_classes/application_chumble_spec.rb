# frozen_string_literal: true

RSpec.describe ApplicationChumble, type: :chumble do
  subject { described_class }

  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }
  it { is_expected.to include_module Conjunction::NamingConvention }
  it { is_expected.to include_module Conjunction::Junction }

  it { is_expected.to be_conjunction_prefix }
  it { is_expected.not_to be_conjunction_suffix }
  it { is_expected.to have_conjunction_prefix "Chumble::" }

  it { is_expected.to have_junction_key :chumble }
end

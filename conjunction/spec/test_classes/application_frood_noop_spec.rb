# frozen_string_literal: true

RSpec.describe ApplicationFroodNoop, type: :frood_noop do
  subject { described_class }

  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }
  it { is_expected.to include_module Conjunction::NamingConvention }
  it { is_expected.to include_module Conjunction::Junction }

  it { is_expected.to be_conjunction_prefix }
  it { is_expected.to be_conjunction_suffix }
  it { is_expected.to have_conjunction_prefix "Frood" }
  it { is_expected.to have_conjunction_suffix "Noop" }

  it { is_expected.to have_junction_key :frood_noop }
end

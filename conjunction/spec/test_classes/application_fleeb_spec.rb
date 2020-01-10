# frozen_string_literal: true

RSpec.describe ApplicationFleeb, type: :fleeb do
  subject { described_class }

  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }
  it { is_expected.to include_module Conjunction::NamingConvention }
  it { is_expected.to include_module Conjunction::Junction }

  it { is_expected.not_to be_conjunction_prefix }
  it { is_expected.to be_conjunction_suffix }
  it { is_expected.to have_conjunction_suffix "Fleeb" }

  it { is_expected.to have_junction_key :fleeb }
end

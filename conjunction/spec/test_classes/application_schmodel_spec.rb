# frozen_string_literal: true

RSpec.describe ApplicationSchmodel, type: :schmodel do
  it { is_expected.to extend_module ActiveModel::Naming }

  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }
end

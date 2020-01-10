# frozen_string_literal: true

RSpec.describe ApplicationPoro, type: :poro do
  it { is_expected.to include_module Conjunction::Prototype }
  it { is_expected.to include_module Conjunction::Conjunctive }
end

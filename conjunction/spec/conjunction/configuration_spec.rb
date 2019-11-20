# frozen_string_literal: true

RSpec.describe Conjunction::Configuration, type: :configuration do
  it { is_expected.to extend_module Spicerack::Configurable }
end

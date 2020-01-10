# frozen_string_literal: true

RSpec.describe CommonFroodNoop, type: :frood_noop do
  it { is_expected.to inherit_from ApplicationFroodNoop }

  it { is_expected.not_to define_prototype }

  it { is_expected.to be_conjugated_from HighFrequencyRadioBurst }
  it { is_expected.to be_conjugated_from PlanetaryAddress }
end

# frozen_string_literal: true

RSpec.describe Chumble::Generic, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.not_to define_prototype }

  it { is_expected.to be_conjugated_from HighFrequencyRadioBurst }
  it { is_expected.to be_conjugated_from PlanetaryAddress }
end

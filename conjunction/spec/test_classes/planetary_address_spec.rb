# frozen_string_literal: true

RSpec.describe PlanetaryAddress, type: :schmodel do
  it { is_expected.to inherit_from ApplicationSchmodel }

  it { is_expected.to have_prototype described_class }
  it { is_expected.to have_prototype_name "PlanetaryAddress" }

  it { is_expected.to be_conjoined_to Chumble::Generic }
  it { is_expected.to be_conjoined_to CommonFroodNoop }

  it { is_expected.to conjugate_into PlanetaryAddressFleeb }
  it { is_expected.to conjugate_into Chumble::Generic }
  it { is_expected.to conjugate_into CommonFroodNoop }
end

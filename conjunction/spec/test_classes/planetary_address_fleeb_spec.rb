# frozen_string_literal: true

RSpec.describe PlanetaryAddressFleeb, type: :fleeb do
  it { is_expected.to inherit_from ApplicationFleeb }

  it { is_expected.to have_prototype PlanetaryAddress }
  it { is_expected.to have_prototype_name "PlanetaryAddress" }

  it { is_expected.to be_conjugated_from PlanetaryAddress }
end

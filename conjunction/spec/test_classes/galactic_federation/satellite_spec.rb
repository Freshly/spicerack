# frozen_string_literal: true

RSpec.describe GalacticFederation::Satellite, type: :poro do
  it { is_expected.to inherit_from ApplicationPoro }

  it { is_expected.to have_prototype described_class }
  it { is_expected.to have_prototype_name "GalacticFederation::Satellite" }

  it { is_expected.to conjugate_into GalacticFederation::SatelliteFleeb }
  it { is_expected.to conjugate_into Chumble::GalacticFederation::Satellite }
  it { is_expected.to conjugate_into GalacticFederation::SatelliteFiddlesticks }
end

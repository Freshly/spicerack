# frozen_string_literal: true

RSpec.describe GalacticFederation::SatelliteFleeb, type: :fleeb do
  it { is_expected.to inherit_from ApplicationFleeb }

  it { is_expected.to have_prototype GalacticFederation::Satellite }
  it { is_expected.to have_prototype_name "GalacticFederation::Satellite" }

  it { is_expected.to be_conjugated_from GalacticFederation::Satellite }
end

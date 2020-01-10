# frozen_string_literal: true

RSpec.describe GalacticFederation::EarthlingFleeb, type: :fleeb do
  it { is_expected.to inherit_from ApplicationFleeb }

  it { is_expected.to have_prototype GalacticFederation::Earthling }
  it { is_expected.to have_prototype_name "GalacticFederation::Earthling" }

  it { is_expected.to be_conjugated_from GalacticFederation::Earthling }
end

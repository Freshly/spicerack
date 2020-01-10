# frozen_string_literal: true

RSpec.describe FroodGalacticFederation::EarthlingNoop, type: :frood_noop do
  it { is_expected.to inherit_from ApplicationFroodNoop }

  it { is_expected.to have_prototype GalacticFederation::Earthling }
  it { is_expected.to have_prototype_name "GalacticFederation::Earthling" }

  it { is_expected.to be_conjugated_from GalacticFederation::Earthling }
end

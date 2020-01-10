# frozen_string_literal: true

RSpec.describe GalacticFederation::Earthling, type: :schmodel do
  it { is_expected.to inherit_from ApplicationSchmodel }

  it { is_expected.to have_prototype described_class }
  it { is_expected.to have_prototype_name "GalacticFederation::Earthling" }

  it { is_expected.to conjugate_into GalacticFederation::EarthlingFleeb }
  it { is_expected.to conjugate_into Chumble::GalacticFederation::Earthling }
  it { is_expected.to conjugate_into FroodGalacticFederation::EarthlingNoop }
end

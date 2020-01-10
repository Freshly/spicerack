# frozen_string_literal: true

RSpec.describe Chumble::GalacticFederation::Earthling, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.to have_prototype GalacticFederation::Earthling }
  it { is_expected.to have_prototype_name "GalacticFederation::Earthling" }

  it { is_expected.to be_conjugated_from GalacticFederation::Earthling }
end

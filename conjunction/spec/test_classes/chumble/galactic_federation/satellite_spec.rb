# frozen_string_literal: true

RSpec.describe Chumble::GalacticFederation::Satellite, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.to have_prototype GalacticFederation::Satellite }
  it { is_expected.to have_prototype_name "GalacticFederation::Satellite" }

  it { is_expected.to be_conjugated_from GalacticFederation::Satellite }
end

# frozen_string_literal: true

RSpec.describe GenericDingleBop, type: :dingle_bop do
  it { is_expected.to inherit_from ApplicationDingleBop }

  it { is_expected.not_to define_prototype }

  it { is_expected.to be_conjugated_from HighFrequencyRadioBurst }
end

# frozen_string_literal: true

RSpec.describe MartianFiddlesticks, type: :dingle_bop do
  it { is_expected.to inherit_from ApplicationDingleBop }

  it { is_expected.to have_prototype Martian }
  it { is_expected.to have_prototype_name "Martian" }

  it { is_expected.to be_conjugated_from Martian }
end

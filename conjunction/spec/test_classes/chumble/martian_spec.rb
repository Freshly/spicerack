# frozen_string_literal: true

RSpec.describe Chumble::Martian, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.to have_prototype Martian }
  it { is_expected.to have_prototype_name "Martian" }

  it { is_expected.to be_conjugated_from Martian }
end

# frozen_string_literal: true

RSpec.describe Chumble::Starlight, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.to have_prototype Starlight }
  it { is_expected.to have_prototype_name "Starlight" }

  it { is_expected.to be_conjugated_from Starlight }
end

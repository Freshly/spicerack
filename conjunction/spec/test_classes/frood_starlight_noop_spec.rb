# frozen_string_literal: true

RSpec.describe FroodStarlightNoop, type: :frood_noop do
  it { is_expected.to inherit_from ApplicationFroodNoop }

  it { is_expected.to have_prototype Starlight }
  it { is_expected.to have_prototype_name "Starlight" }

  it { is_expected.to be_conjugated_from Starlight }
end

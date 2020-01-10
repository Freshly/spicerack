# frozen_string_literal: true

RSpec.describe Starlight, type: :poro do
  it { is_expected.to inherit_from ApplicationPoro }

  it { is_expected.to have_prototype described_class }
  it { is_expected.to have_prototype_name "Starlight" }

  it { is_expected.to conjugate_into StarlightFleeb }
  it { is_expected.to conjugate_into Chumble::Starlight }
  it { is_expected.to conjugate_into FroodStarlightNoop }
end

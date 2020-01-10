# frozen_string_literal: true

RSpec.describe Chumble::Luna, type: :chumble do
  it { is_expected.to inherit_from ApplicationChumble }

  it { is_expected.to have_prototype Luna }
  it { is_expected.to have_prototype_name "Luna" }

  it { is_expected.to be_conjugated_from Luna }
end

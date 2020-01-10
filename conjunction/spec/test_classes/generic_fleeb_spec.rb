# frozen_string_literal: true

RSpec.describe GenericFleeb, type: :fleeb do
  it { is_expected.to inherit_from ApplicationFleeb }

  it { is_expected.not_to define_prototype }

  it { is_expected.to be_conjugated_from HighFrequencyRadioBurst }
  it { is_expected.to be_conjugated_from Luna }
end

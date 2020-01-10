# frozen_string_literal: true

RSpec.describe FroodMartianNoop, type: :frood_noop do
  it { is_expected.to inherit_from ApplicationFroodNoop }

  it { is_expected.to have_prototype Martian }
  it { is_expected.to have_prototype_name "Martian" }

  it { is_expected.to be_conjugated_from Martian }
end

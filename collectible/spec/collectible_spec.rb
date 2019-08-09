# frozen_string_literal: true

RSpec.describe Collectible do
  it_behaves_like "a versioned spicerack gem"

  describe Collectible::ItemNotAllowedError do
    it { is_expected.to inherit_from StandardError }
  end

  describe Collectible::ItemTypeMismatchError do
    it { is_expected.to inherit_from Collectible::ItemNotAllowedError }
  end

  describe Collectible::TypeEnforcementAlreadyDefined do
    it { is_expected.to inherit_from StandardError }
  end

  describe Collectible::MethodNotAllowedError do
    it { is_expected.to inherit_from StandardError }
  end
end

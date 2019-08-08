# frozen_string_literal: true

RSpec.describe Collectible::CollectionBase do
  it { is_expected.to include_module AroundTheWorld }

  it { is_expected.to include_module Tablesalt::StringableObject }
  it { is_expected.to include_module Tablesalt::UsesHashForEquality }

  it { is_expected.to include_module Collectible::Collection::Core }
  it { is_expected.to include_module Collectible::Collection::EnsuresItemEligibility }
  it { is_expected.to include_module Collectible::Collection::WrapsCollectionMethods }
end


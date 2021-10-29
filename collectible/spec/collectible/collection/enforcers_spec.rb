# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers do
  let(:items) { [ 1, 2, 3 ] }
  let(:new_items) { [ 42, 17 ] }

  subject(:factory) { described_class }

  describe ".with_first_element" do
    it "builds WithFirstElement validator" do
      expect(
        factory.with_first_element(items, new_items),
      ).to be_instance_of(
        Collectible::Collection::Enforcers::WithFirstElement,
      )
    end
  end

  describe ".with_proc" do
    it "builds WithProc validator" do
      expect(
        factory.with_proc(items, new_items, validate_with: -> {}),
      ).to be_instance_of(
        Collectible::Collection::Enforcers::WithProc,
      )
    end
  end

  describe ".with_type" do
    it "builds WithType validator" do
      expect(
        factory.with_type(items, new_items, validate_with: String),
      ).to be_instance_of(
        Collectible::Collection::Enforcers::WithType,
      )
    end
  end
end

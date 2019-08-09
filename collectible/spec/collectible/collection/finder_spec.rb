# frozen_string_literal: true

# frozen_string_literal: true

RSpec.describe Collectible::Collection::Finder, type: :concern do
  include_context "with an example collection"

  let(:items) { [ item0, item1, item2 ] }

  let(:item_class) { Struct.new(:name, :even, :something) }

  let(:item0) { item_class.new(:item0, true, false) }
  let(:item1) { item_class.new(:item1, false, true) }
  let(:item2) { item_class.new(:item2, true, true) }

  describe "#find_by" do
    subject(:find_by) { example_collection.find_by(**options) }

    context "with unexpected options" do
      let(:options) { Hash[attribute, SecureRandom.hex] }
      let(:attribute) { SecureRandom.hex.to_sym }

      it "raises" do
        expect { find_by }.to raise_error NoMethodError, "undefined method `#{attribute}' for #{item0}"
      end
    end

    context "without matching options" do
      let(:options) { Hash[:name, SecureRandom.hex] }

      it { is_expected.to be_nil }
    end

    context "when one option matches" do
      let(:expected_item) { items.sample }
      let(:options) { Hash[:name, expected_item.name] }

      it { is_expected.to eq expected_item }
    end

    context "when one option matches but another does not" do
      let(:random_item) { items.sample }
      let(:options) do
        { name: random_item.name, even: !random_item.even }
      end

      it { is_expected.to be_nil }
    end

    context "when multiple options matches" do
      let(:expected_item) { items.sample }
      let(:options) do
        { name: expected_item.name, something: expected_item.something }
      end

      it { is_expected.to eq expected_item }
    end
  end

  describe "#where" do
    subject(:where) { example_collection.where(**options) }

    context "with unexpected options" do
      let(:options) { Hash[attribute, SecureRandom.hex] }
      let(:attribute) { SecureRandom.hex.to_sym }

      it "raises" do
        expect { where }.to raise_error NoMethodError, "undefined method `#{attribute}' for #{item0}"
      end
    end

    context "without matching options" do
      let(:options) { Hash[:name, SecureRandom.hex] }

      it { is_expected.to be_an_instance_of example_collection_class }
      it { is_expected.to be_empty }
    end

    context "when one option matches" do
      let(:expected_item) { items.sample }
      let(:options) { Hash[:name, expected_item.name] }

      it { is_expected.to be_an_instance_of example_collection_class }
      it { is_expected.to eq example_collection_class.new(expected_item) }
    end

    context "when one option matches but another does not" do
      let(:random_item) { items.sample }
      let(:options) do
        { name: random_item.name, even: !random_item.even }
      end

      it { is_expected.to be_an_instance_of example_collection_class }
      it { is_expected.to be_empty }
    end

    context "when multiple options matches" do
      let(:options) { Hash[:something, true] }

      it { is_expected.to eq example_collection_class.new(item1, item2) }
    end
  end
end

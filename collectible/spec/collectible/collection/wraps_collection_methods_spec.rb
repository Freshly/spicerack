# frozen_string_literal: true

RSpec.describe Collectible::Collection::WrapsCollectionMethods, type: :concern do
  include_context "with an example collection"

  shared_examples_for "collection methods are wrapped" do
    let(:added_item) { Faker::Hipster.word }

    shared_examples_for "it returns the same collection" do
      it { is_expected.to equal example_collection }
      it "returns the same collection" do
        expect(returned_collection).to equal example_collection
      end
    end

    shared_examples_for "it returns the same collection with new items" do
      it_behaves_like "it returns the same collection"

      it "returns the same collection" do
        expect(returned_collection).to be_a example_collection_class
        expect(returned_collection).to eq matching_collection
      end
    end

    shared_examples_for "it returns a matching collection" do
      it "returns a matching collection" do
        expect(returned_collection).to be_a example_collection_class
        expect(returned_collection).to eq matching_collection
        expect(returned_collection).not_to equal example_collection
      end
    end

    describe "#select" do
      subject(:returned_collection) { example_collection.select(&:present?) }

      it_behaves_like "it returns a matching collection" do
        let(:matching_collection) { example_collection_class.new(items.select(&:present?)) }
      end
    end

    describe "#push" do
      subject(:returned_collection) { example_collection.push(added_item) }

      it_behaves_like "it returns the same collection with new items" do
        let(:matching_collection) { example_collection_class.new(items.push(added_item)) }
      end
    end

    describe "#<<" do
      subject(:returned_collection) { example_collection << added_item }

      it_behaves_like "it returns the same collection with new items" do
        let(:matching_collection) { example_collection_class.new(items << added_item) }
      end
    end

    describe "#concat" do
      subject(:returned_collection) { example_collection.concat(added_items) }

      let(:matching_collection) { example_collection_class.new(items.concat(added_items)) }

      context "when argument is an array" do
        let(:added_items) { [ added_item ] }

        it_behaves_like "it returns the same collection with new items"
      end

      context "when argument is a collection" do
        let(:added_items) { example_collection_class.new([ added_item ]) }

        it_behaves_like "it returns the same collection with new items"
      end
    end

    describe "#+" do
      subject(:returned_collection) { example_collection + added_items }

      let(:matching_collection) { example_collection_class.new(items + added_items) }

      context "when argument is an array" do
        let(:added_items) { [ added_item ] }

        it_behaves_like "it returns a matching collection"
      end

      context "when argument is a collection" do
        let(:added_items) { example_collection_class.new([ added_item ]) }

        it_behaves_like "it returns a matching collection"
      end
    end

    describe "#-" do
      subject(:returned_collection) { example_collection - removed_items }

      let(:matching_collection) { example_collection_class.new(items - removed_items) }

      context "when argument is an array" do
        let(:removed_items) { [ items.sample ] }

        it_behaves_like "it returns a matching collection"
      end

      context "when argument is a collection" do
        let(:removed_items) { example_collection_class.new([ items.sample ]) }

        it_behaves_like "it returns a matching collection"
      end
    end

    describe "#each" do
      subject(:returned_collection) { example_collection.each { } }

      it_behaves_like "it returns the same collection"
    end

    describe "#reverse_each" do
      subject(:returned_collection) { example_collection.each { } }

      it_behaves_like "it returns the same collection"
    end

    describe "#uniq" do
      subject(:returned_collection) { example_collection.uniq }

      it_behaves_like "it returns a matching collection" do
        let(:matching_collection) { example_collection_class.new(items.uniq) }
      end
    end

    describe "#uniq!" do
      # uniq! returns elements removed, so the collection it returns is never the collection we're testing against
      subject(:returned_collection) { example_collection }

      it_behaves_like "it returns the same collection" do
        let(:matching_collection) { example_collection_class.new(items.uniq) }

        before do
          example_collection << example_collection.last
          example_collection.uniq!
        end
      end
    end

    describe "#[]" do
      context "when one argument is given" do
        subject { example_collection[index] }

        let(:index) { rand(items.length) }

        it { is_expected.to eq items[index] }
      end

      context "when multiple arguments are given" do
        subject(:returned_collection) { example_collection[*access_params] }

        let(:access_params) { [ rand(items.length), rand(items.length) ] }

        it_behaves_like "it returns a matching collection" do
          let(:matching_collection) { example_collection_class.new(items[*access_params]) }
        end
      end
    end

    describe "#first" do
      context "when no arguments are given" do
        subject { example_collection.first }

        it { is_expected.to eq items.first }
      end

      context "when arguments are given" do
        subject(:returned_collection) { example_collection.first(length) }

        let(:length) { rand(items.length) }

        it_behaves_like "it returns a matching collection" do
          let(:matching_collection) { example_collection_class.new(items.first(length)) }
        end
      end
    end

    describe "#last" do
      context "when no arguments are given" do
        subject { example_collection.last }

        it { is_expected.to eq items.last }
      end

      context "when arguments are given" do
        subject(:returned_collection) { example_collection.last(length) }

        let(:length) { rand(items.length) }

        it_behaves_like "it returns a matching collection" do
          let(:matching_collection) { example_collection_class.new(items.last(length)) }
        end
      end
    end

    describe "#shift" do
      context "when no arguments are given" do
        subject { example_collection.shift }

        it { is_expected.to eq items.shift }
      end

      context "when arguments are given" do
        subject(:returned_collection) { example_collection.shift(length) }

        let(:length) { rand(items.length) }

        it_behaves_like "it returns a matching collection" do
          let(:matching_collection) { example_collection_class.new(items.shift(length)) }
        end
      end
    end

    describe "#pop" do
      context "when no arguments are given" do
        subject { example_collection.pop }

        it { is_expected.to eq items.pop }
      end

      context "when arguments are given" do
        subject(:returned_collection) { example_collection.pop(length) }

        let(:length) { rand(items.length) }

        it_behaves_like "it returns a matching collection" do
          let(:matching_collection) { example_collection_class.new(items.pop(length)) }
        end
      end
    end

    describe "#group_by" do
      subject { example_collection.group_by(&:blank?).values }

      it { is_expected.to all be_a example_collection_class }
      it { is_expected.to match_array items.group_by(&:blank?).values.map { |group| example_collection_class.new(group) } }
    end

    describe "#partition" do
      subject { example_collection.partition(&:blank?) }

      it { is_expected.to all be_a example_collection_class }
      it { is_expected.to match_array(items.partition(&:blank?).map { |group| example_collection_class.new(group) }) }
    end
  end

  context "when empty" do
    let(:items) { [] }

    it_behaves_like "collection methods are wrapped"
  end

  context "with items" do
    let(:items) { [ SecureRandom.hex ] }

    it_behaves_like "collection methods are wrapped"
  end
end

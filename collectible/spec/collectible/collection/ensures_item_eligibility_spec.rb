# frozen_string_literal: true

require "spec_helper"

RSpec.describe Collectible::Collection::EnsuresItemEligibility, type: :concern do
  subject(:example_collection) { collection_class.new }

  let(:collection_class) { Class.new(::Collectible::CollectionBase) }

  %i[push << unshift prepend].each do |method_name|
    it_behaves_like "it ensures item validity before", method_name
  end

  describe "#initialize" do
    subject { collection_class }

    context "with default validation" do
      context "when all new items are valid" do
        it "creates a collection" do
          expect { collection_class.new([ 1, 2, 3 ]) }.not_to raise_error
        end
      end

      context "when there are invalid new items" do
        it "raises" do
          expect { collection_class.new([ 1, 2, "string" ]) }.to raise_error(
            Collectible::ItemTypeMismatchError, %r{item mismatch}
          )
        end
      end
    end
  end

  describe "#concat" do
    context "with default validation" do
      context "when no items present in collection" do
        context "with all new items valid" do
          it "adds new items" do
            expect { example_collection.concat([ 1 ]) }.to change { example_collection.items }.from([]).to([ 1 ])
          end
        end

        context "when there are invalid new items" do
          it "raises" do
            expect { example_collection.concat([ 1, "string" ]) }.to raise_error(
              Collectible::ItemTypeMismatchError, %r{item mismatch}
            )
          end
        end
      end

      context "when there are items in collection" do
        before { example_collection.push(1) }

        context "with all new items valid" do
          it "adds them" do
            expect(example_collection.items).to match_array([ 1 ])
            example_collection.concat([ 2, 3 ])
            expect(example_collection.items).to match_array([ 1, 2, 3 ])
          end
        end

        context "when there are invalid new items" do
          it "raises" do
            expect { example_collection.concat([ 2, "string" ]) }.to raise_error(
              Collectible::ItemTypeMismatchError, %r{item mismatch}
            )
          end
        end
      end
    end
  end

  describe "#insert" do
    context "with default validation" do
      context "when no items present in collection" do
        context "with all new items valid" do
          it "adds new items" do
            expect { example_collection.insert(0, 1) }.to change { example_collection.items }.from([]).to([ 1 ])
          end
        end

        context "when there are invalid new items" do
          it "raises" do
            expect { example_collection.insert(0, 1, "string") }.to raise_error(
              Collectible::ItemTypeMismatchError, %r{item mismatch}
            )
          end
        end
      end

      context "when there are items in collection" do
        before { example_collection.push(1) }

        context "when all new items valid" do
          it "adds them" do
            expect(example_collection.items).to match_array([ 1 ])
            example_collection.insert(0, 2, 3)
            expect(example_collection.items).to match_array([ 1, 2, 3 ])
          end
        end

        context "when there are invalid new items" do
          it "raises" do
            expect { example_collection.insert(0, 2, "string") }.to raise_error(
              Collectible::ItemTypeMismatchError, %r{item mismatch}
            )
          end
        end
      end
    end
  end
end

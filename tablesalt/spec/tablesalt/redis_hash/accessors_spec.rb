# frozen_string_literal: true

RSpec.describe Tablesalt::RedisHash::Accessors, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:assoc).to(:to_h) }
  it { is_expected.to delegate_method(:compact).to(:to_h) }
  it { is_expected.to delegate_method(:dig).to(:to_h) }
  it { is_expected.to delegate_method(:fetch_values).to(:to_h) }
  it { is_expected.to delegate_method(:flatten).to(:to_h) }
  it { is_expected.to delegate_method(:key).to(:to_h) }
  it { is_expected.to delegate_method(:rassoc).to(:to_h) }
  it { is_expected.to delegate_method(:rehash).to(:to_h) }

  describe "#[]" do
    subject { example_redis_hash[field] }

    let(:field) { SecureRandom.hex }

    context "with existing data" do
      include_context "with data in redis"

      context "with matching field" do
        let(:field) { field0 }

        it { is_expected.to eq value0 }
      end

      context "without matching field" do
        it { is_expected.to be_nil }
      end
    end

    context "without existing data" do
      it { is_expected.to be_nil }
    end
  end

  describe "#fetch" do
    let(:field) { SecureRandom.hex }

    context "without a block or default" do
      subject(:fetch) { example_redis_hash.fetch(field) }

      context "with existing data" do
        include_context "with data in redis"

        let(:field) { field0 }

        it { is_expected.to eq value0 }
      end

      context "without existing data" do
        it "raises" do
          expect { fetch }.to raise_error KeyError, "key not found: \"#{field}\""
        end
      end
    end

    context "with a default" do
      subject(:fetch) { example_redis_hash.fetch(field, :default) }

      context "with existing data" do
        include_context "with data in redis"

        let(:field) { field0 }

        it { is_expected.to eq value0 }
      end

      context "without existing data" do
        it { is_expected.to eq :default }
      end
    end

    context "with a block" do
      subject(:fetch) do
        example_redis_hash.fetch(field) { |el| "#{el}_return_value" }
      end

      context "with existing data" do
        include_context "with data in redis"

        let(:field) { field0 }

        it { is_expected.to eq value0 }
      end

      context "without existing data" do
        it { is_expected.to eq "#{field}_return_value" }
      end
    end
  end

  describe "#keys" do
    subject { example_redis_hash.keys }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to match_array expected_hash.keys }
    end

    context "without existing data" do
      it { is_expected.to eq [] }
    end
  end

  describe "#length" do
    subject { example_redis_hash.length }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to eq expected_hash.length }
    end

    context "without existing data" do
      it { is_expected.to eq 0 }
    end
  end

  describe "#values" do
    subject { example_redis_hash.values }

    context "with existing data" do
      include_context "with data in redis"

      it { is_expected.to match_array expected_hash.values }
    end

    context "without existing data" do
      it { is_expected.to eq [] }
    end
  end

  describe "#values_at" do
    let(:field2) { SecureRandom.hex }
    let(:fields) { [ field0, field2, field1 ] }

    shared_examples_for "expected values are returned" do
      context "with existing data" do
        include_context "with data in redis"

        it { is_expected.to eq [ value0, nil, value1 ] }
      end

      context "without existing data" do
        let(:field0) { SecureRandom.hex }
        let(:field1) { SecureRandom.hex }

        it { is_expected.to eq [ nil, nil, nil ] }
      end
    end

    context "with arguments" do
      subject { example_redis_hash.values_at(*fields) }

      it_behaves_like "expected values are returned"
    end

    context "with array" do
      subject { example_redis_hash.values_at(fields) }

      it_behaves_like "expected values are returned"
    end
  end
end

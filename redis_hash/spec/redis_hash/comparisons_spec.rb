# frozen_string_literal: true

RSpec.describe RedisHash::Comparisons, type: :module do
  include_context "with an example redis hash", described_class

  it { is_expected.to delegate_method(:compare_by_identity).to(:to_h) }
  it { is_expected.to delegate_method(:compare_by_identity?).to(:to_h) }

  it { is_expected.to alias_method :==, :eql? }

  describe "#==" do
    subject { example_redis_hash == other }

    context "when other is nil" do
      let(:other) { nil }

      it { is_expected.to be false }
    end

    context "when other is something else" do
      let(:other) { SecureRandom.hex }

      it { is_expected.to be false }
    end

    context "when other is a redis hash" do
      let(:other) { example_redis_hash_class.new(redis_key: other_key, redis: other_redis) }
      let(:different_redis) { Redis.new(db: 15) }

      context "with matching key" do
        let(:other_key) { redis_key }

        context "with matching redis" do
          let(:other_redis) { redis }

          it { is_expected.to be true }
        end

        context "with different redis" do
          let(:other_redis) { different_redis }

          it { is_expected.to be false }
        end
      end

      context "with different key" do
        let(:other_key) { SecureRandom.hex }

        context "with matching redis" do
          let(:other_redis) { redis }

          it { is_expected.to be false }
        end

        context "with different redis" do
          let(:other_redis) { different_redis }

          it { is_expected.to be false }
        end
      end
    end
  end

  shared_examples_for "an expected comparison" do |for_subset: false, for_superset: false, for_sameset: false|
    include_context "with data in redis"

    let(:subset) { Hash[field0, value0] }
    let(:superset) { subset.merge(field1 => value1, SecureRandom.hex => SecureRandom.hex) }

    context "when other is a subset" do
      let(:other) { subset }

      it { is_expected.to eq for_subset }
    end

    context "when other is a superset" do
      let(:other) { superset }

      it { is_expected.to eq for_superset }
    end

    context "when other is equal" do
      let(:other) { expected_hash }

      it { is_expected.to eq for_sameset }
    end
  end

  describe "#<" do
    subject { example_redis_hash < other }

    it_behaves_like "an expected comparison", for_superset: true
  end

  describe "#<=" do
    subject { example_redis_hash <= other }

    it_behaves_like "an expected comparison", for_superset: true, for_sameset: true
  end

  describe "#>" do
    subject { example_redis_hash > other }

    it_behaves_like "an expected comparison", for_subset: true
  end

  describe "#>=" do
    subject { example_redis_hash >= other }

    it_behaves_like "an expected comparison", for_subset: true, for_sameset: true
  end
end

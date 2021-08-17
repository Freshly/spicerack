# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor::Management do
  let(:example_class) do
    Class.new do
      include Tablesalt::ThreadAccessor

      thread_accessor :current_balderdash, :balderdash, private: false
    end
  end
  let(:sample_value) { Faker::ChuckNorris.fact }

  describe ".store" do
    subject { Tablesalt::ThreadAccessor.store }

    it { is_expected.to eq({}) }
    it { is_expected.to be_a Tablesalt::ThreadAccessor::ThreadStore }
    it { is_expected.to eq Tablesalt::ThreadAccessor::ThreadStore.new }
    it { is_expected.to equal Tablesalt::ThreadAccessor.store }

    context "when namespace is given" do
      subject { Tablesalt::ThreadAccessor.store(namespace) }

      let(:namespace) { Faker::Lorem.word }

      it { is_expected.to eq({}) }
      it { is_expected.to be_a Tablesalt::ThreadAccessor::ThreadStore }
      it { is_expected.to eq Tablesalt::ThreadAccessor::ThreadStore.new }
      it { is_expected.to equal Tablesalt::ThreadAccessor.store(namespace) }
      it { is_expected.not_to equal Tablesalt::ThreadAccessor.store }
    end
  end

  describe ".clean_thread_context" do
    before do
      allow(example_class).to receive(:current_balderdash=).and_call_original
    end

    it "clears the variables written inside the block" do
      Tablesalt::ThreadAccessor.clean_thread_context do
        example_class.current_balderdash = sample_value

        expect(example_class.current_balderdash).to eq sample_value
      end

      expect(example_class.current_balderdash).to eq nil
      expect(example_class).to have_received(:current_balderdash=).with(sample_value).once
    end

    context "when namespace is set" do
      let(:namespace) { Faker::Lorem.word }
      let(:key) { Faker::Hipster.words.join("-").parameterize }
      let(:value) { rand }

      it "clears the namespaced store" do
        Tablesalt::ThreadAccessor.clean_thread_context(namespace: namespace) do
          Tablesalt::ThreadAccessor.store(namespace)[key] = value

          expect(Tablesalt::ThreadAccessor.store(namespace)[key]).to eq value
        end

        expect(Tablesalt::ThreadAccessor.store(namespace)[key]).to be_nil
      end

      it "does not clear the global store" do
        Tablesalt::ThreadAccessor.clean_thread_context(namespace: namespace) do
          Tablesalt::ThreadAccessor.store[key] = value
        end

        expect(Tablesalt::ThreadAccessor.store[key]).to eq value
      end

      it "does not clear other namespaced stores" do
        Tablesalt::ThreadAccessor.clean_thread_context(namespace: namespace) do
          Tablesalt::ThreadAccessor.store(:balderdash)[key] = value
        end

        expect(Tablesalt::ThreadAccessor.store(:balderdash)[key]).to eq value
      end
    end
  end
end

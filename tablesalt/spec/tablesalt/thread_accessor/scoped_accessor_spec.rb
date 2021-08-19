# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor::ScopedAccessor do
  subject(:mod) { described_class.new(namespace) }

  let(:namespace) { Faker::Lorem.words.join("-").underscore }
  let(:example_class) do
    Class.new.tap do |klass|
      klass.instance_exec(self) do |spec|
        include spec.mod
      end
    end
  end

  it { is_expected.to extend_module ActiveSupport::Concern }
  it { is_expected.to extend_module Tablesalt::ThreadAccessor::Management }

  context "when included by a class" do
    subject { example_class }

    it { is_expected.to include_module mod }
    it { is_expected.to include_module Tablesalt::ThreadAccessor }
  end

  describe "singleton methods" do
    describe "#name" do
      subject { mod.name }

      it { is_expected.to eq "#{described_class}:#{namespace}"}
    end

    describe "#inspeect" do
      subject { mod.inspect }

      it { is_expected.to eq "#<#{mod.name}>" }
    end
  end

  describe "provided class methods" do
    let(:instance) { example_class.new }
    let(:method) { Faker::Lorem.word.to_sym }
    let(:thread_key) { Faker::Hipster.sentence }

    describe ".thread_reader" do
      let(:private?) { true }

      before { example_class.__send__(:thread_reader, method, thread_key, private: private?) }

      it "is private" do
        expect { example_class.thread_reader(method, thread_key) }.to raise_error(NoMethodError)
      end

      context "when private option is true" do
        let(:private?) { true }

        it_behaves_like "a thread reader" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread reader" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end

      context "when private option is false" do
        let(:private?) { false }

        it_behaves_like "a thread reader" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread reader" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end
    end

    describe ".thread_writer" do
      let(:private?) { true }

      before { example_class.__send__(:thread_writer, method, thread_key, private: private?) }

      it "is private" do
        expect { example_class.thread_writer(method, thread_key) }.to raise_error(NoMethodError)
      end

      context "when private option is true" do
        let(:private?) { true }

        it_behaves_like "a thread writer" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread writer" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end

      context "when private option is false" do
        let(:private?) { false }

        it_behaves_like "a thread writer" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread writer" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end
    end

    describe ".thread_accessor" do
      let(:private?) { true }

      before { example_class.__send__(:thread_accessor, method, thread_key, private: private?) }

      it "is private" do
        expect { example_class.thread_accessor(method, thread_key) }.to raise_error(NoMethodError)
      end

      context "when private option is true" do
        let(:private?) { true }

        it_behaves_like "a thread accessor" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread accessor" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end

      context "when private option is false" do
        let(:private?) { false }

        it_behaves_like "a thread accessor" do
          let(:receiver) { instance }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end

        it_behaves_like "a thread accessor" do
          let(:receiver) { example_class }
          let(:namespace) { Faker::Lorem.sentence.parameterize }
        end
      end
    end
  end
end

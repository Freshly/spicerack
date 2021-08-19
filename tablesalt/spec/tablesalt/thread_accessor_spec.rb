# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor do
  let(:example_class) { Class.new.include described_class }
  let(:instance) { example_class.new }

  let(:method) { Faker::Lorem.word.to_sym }
  let(:thread_key) { Faker::Lorem.sentence.parameterize.underscore.to_sym }
  let(:private?) { true }

  it { expect(example_class.private_methods).to include :__thread_accessor_store_instance__ }

  describe ".[]" do
    subject(:mod) { described_class[namespace] }

    let(:namespace) { Faker::Lorem.word }

    it { is_expected.to be_a described_class::ScopedAccessor }

    it "has the specified namespace" do
      expect(mod.scope).to eq namespace
    end
  end

  describe ".thread_reader" do
    before { example_class.__send__(:thread_reader, method, thread_key, private: private?) }

    it "is private" do
      expect { example_class.thread_reader(method, thread_key) }.to raise_error(NoMethodError)
    end

    context "when private option is true" do
      let(:private?) { true }

      it_behaves_like "a thread reader" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread reader" do
        let(:receiver) { example_class }
      end
    end

    context "when private option is false" do
      let(:private?) { false }

      it_behaves_like "a thread reader" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread reader" do
        let(:receiver) { example_class }
      end
    end
  end

  describe ".thread_writer" do
    before { example_class.__send__(:thread_writer, method, thread_key, private: private?) }

    it "is private" do
      expect { example_class.thread_writer(method, thread_key) }.to raise_error(NoMethodError)
    end

    context "when private option is true" do
      let(:private?) { true }

      it_behaves_like "a thread writer" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread writer" do
        let(:receiver) { example_class }
      end
    end

    context "when private option is false" do
      let(:private?) { false }

      it_behaves_like "a thread writer" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread writer" do
        let(:receiver) { example_class }
      end
    end
  end

  describe ".thread_accessor" do
    before { example_class.__send__(:thread_accessor, method, thread_key, private: private?) }

    it "is private" do
      expect { example_class.thread_accessor(method, thread_key) }.to raise_error(NoMethodError)
    end

    context "when private option is true" do
      let(:private?) { true }

      it_behaves_like "a thread accessor" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread accessor" do
        let(:receiver) { example_class }
      end
    end

    context "when private option is false" do
      let(:private?) { false }

      it_behaves_like "a thread accessor" do
        let(:receiver) { instance }
      end

      it_behaves_like "a thread accessor" do
        let(:receiver) { example_class }
      end
    end
  end
end

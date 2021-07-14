# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor do
  let(:example_class) { Class.new.include described_class }
  let(:instance) { example_class.new }

  let(:method) { Faker::Lorem.word.to_sym }
  let(:thread_key) { Faker::Lorem.sentence.parameterize.underscore.to_sym }
  let(:private?) { true }

  it { expect(example_class.private_methods).to include :__thread_accessor_namespace__ }
  it { expect(example_class.private_methods).to include :__thread_accessor_store_instance__ }

  describe ".[]" do
    let(:namespace) { Faker::Lorem.word }
    let(:namespaced_example_class) do
      Class.new.include(described_class[namespace])
    end
    let(:namespaced_instance) { namespaced_example_class.new }

    describe ".thread_reader" do
      before { namespaced_example_class.__send__(:thread_reader, method, thread_key) }

      it_behaves_like "a thread reader" do
        let(:receiver) { namespaced_instance }
      end

      it_behaves_like "a thread reader" do
        let(:receiver) { namespaced_example_class }
      end
    end

    describe ".thread_writer" do
      before { namespaced_example_class.__send__(:thread_writer, method, thread_key) }

      it_behaves_like "a thread writer" do
        let(:receiver) { namespaced_instance }
      end

      it_behaves_like "a thread writer" do
        let(:receiver) { namespaced_example_class }
      end
    end

    describe ".thread_accessor" do
      before { namespaced_example_class.__send__(:thread_accessor, method, thread_key) }

      it_behaves_like "a thread accessor" do
        let(:receiver) { namespaced_instance }
      end

      it_behaves_like "a thread accessor" do
        let(:receiver) { namespaced_example_class }
      end
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

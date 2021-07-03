# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor::Management do
  let(:example_class) do
    Class.new do
      include Tablesalt::ThreadAccessor

      thread_accessor :current_balderdash, :balderdash, private: false
    end
  end
  let(:sample_value) { Faker::ChuckNorris.fact }

  describe ".register_written_thread_variable" do
    subject { Thread.current[example_class::WRITTEN_VARIABLES_THREAD_KEY] }

    let(:name) { Faker::Lorem.unique.word }

    context "when called once" do
      before { Tablesalt::ThreadAccessor.register_written_thread_variable(name) }

      it { is_expected.to eq Set[name.to_sym] }
    end

    context "when called twice with the same name" do
      before do
        Tablesalt::ThreadAccessor.register_written_thread_variable(name)
        Tablesalt::ThreadAccessor.register_written_thread_variable(name)
      end

      it { is_expected.to eq Set[name.to_sym] }
    end

    context "when called twice with different names" do
      let(:name_2) { Faker::Lorem.unique.word }

      before do
        Tablesalt::ThreadAccessor.register_written_thread_variable(name)
        Tablesalt::ThreadAccessor.register_written_thread_variable(name_2)
      end

      it { is_expected.to eq Set[name.to_sym, name_2.to_sym] }
    end
  end

  describe ".clear_thread_variables!" do
    subject { Thread.current[example_class::WRITTEN_VARIABLES_THREAD_KEY] }

    before { Tablesalt::ThreadAccessor.clear_thread_variables! }

    context "when nothing is tracked on thread" do
      it { is_expected.to eq nil }
    end

    context "when one name is set on thread" do
      before do
        Tablesalt::ThreadAccessor.register_written_thread_variable(Faker::Lorem.word)
        Tablesalt::ThreadAccessor.clear_thread_variables!
      end

      it { is_expected.to eq nil }
    end

    context "when multiple names are set on thread" do
      before do
        2.times { Tablesalt::ThreadAccessor.register_written_thread_variable(Faker::Lorem.unique.word) }
        Tablesalt::ThreadAccessor.clear_thread_variables!
      end

      it { is_expected.to eq nil }
    end
  end

  describe ".with_isolated_thread_context" do
    before do
      allow(example_class).to receive(:current_balderdash=).and_call_original
    end

    it "clears the variables written inside the block" do
      Tablesalt::ThreadAccessor.with_isolated_thread_context do
        example_class.current_balderdash = sample_value

        expect(example_class.current_balderdash).to eq sample_value
      end

      expect(example_class.current_balderdash).to eq nil
      expect(example_class).to have_received(:current_balderdash=).with(sample_value).once
    end
  end
end

# frozen_string_literal: true

RSpec.describe Spicerack::ClassFinder do
  subject(:class_finder) { described_class.new(class_type) }

  let(:class_type) { Faker::Internet.domain_word.capitalize }

  it { is_expected.to inherit_from Spicerack::RootObject }

  describe described_class::NotFoundError do
    it { is_expected.to inherit_from StandardError }
  end

  describe "#initialize" do
    it "sets class_type" do
      expect(class_finder.class_type).to eq class_type
    end
  end

  describe "for!" do
    subject(:for!) { class_finder.for!(object) }

    let(:object) { double }

    context "when nil" do
      it "raises" do
        expect { for! }.to raise_error Spicerack::ClassFinder::NotFoundError
      end
    end

    context "when class" do
      let(:class_for) do
        Class.new do
          attr_reader :object

          def initialize(object)
            @object = object
          end
        end
      end

      before { allow(class_finder).to receive(:class_for!).with(object).and_return(class_for) }

      it { is_expected.to be_an_instance_of class_for }
      it { is_expected.to have_attributes(object: object) }
    end
  end

  describe "for" do
    subject(:for) { class_finder.for(object) }

    let(:object) { double }

    context "when nil" do
      it { is_expected.to be_nil }
    end

    context "when class" do
      let(:class_for) do
        Class.new do
          attr_reader :object

          def initialize(object)
            @object = object
          end
        end
      end

      before { allow(class_finder).to receive(:class_for).with(object).and_return(class_for) }

      it { is_expected.to be_an_instance_of class_for }
      it { is_expected.to have_attributes(object: object) }
    end
  end

  describe "#class_for!" do
    subject(:class_for!) { class_finder.class_for!(object) }

    let(:object) { double }

    before { allow(class_finder).to receive(:class_for).with(object).and_return(class_for) }

    context "when nil" do
      let(:class_for) { nil }

      it "raises" do
        expect { class_for! }.
          to raise_error Spicerack::ClassFinder::NotFoundError, "could not find `#{class_type}' for `#{object.inspect}'"
      end
    end

    context "when present" do
      let(:class_for) { Class.new }

      it { is_expected.to eq class_for }
    end
  end

  describe "#class_for" do
    subject(:class_for) { class_finder.class_for(object) }

    context "when nil" do
      let(:object) { nil }

      it { is_expected.to be_nil }
    end

    context "when explicit" do
      let(:explicit_method_name) { class_finder.__send__(:explicit_method_name) }

      context "when on class and instance" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_singleton_method(explicit_method_name) { :class_from_class }
            klass.define_method(explicit_method_name) { :class_from_instance }
          end
        end

        context "with class" do
          let(:object) { object_class }

          it { is_expected.to eq :class_from_class }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :class_from_instance }
        end
      end

      context "when only on instance" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_method(explicit_method_name) { :class_from_instance }
          end
        end

        context "with class" do
          let(:object) { object_class }

          it { is_expected.to be_nil }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :class_from_instance }
        end
      end

      context "when only on class" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_singleton_method(explicit_method_name) { :class_from_class }
          end
        end

        context "with class" do
          let(:object) { object_class }

          it { is_expected.to eq :class_from_class }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :class_from_class }
        end
      end
    end

    context "when implicit" do
      before { allow(class_finder).to receive(:root_name).with(object).and_return(root_name) }

      let(:object) { double }

      let(:root_name) { Faker::Lorem.words(2).join("_").camelize }
      let(:found_class_name) { "#{root_name}#{class_type}" }

      context "when defined" do
        let(:found_class) { Class.new }

        before { stub_const(found_class_name, found_class) }

        it { is_expected.to eq found_class }
      end

      context "when undefined" do
        it { is_expected.to be_nil }
      end
    end
  end

  describe "#root_name" do
    subject(:root_name) { class_finder.__send__(:root_name, object) }

    context "when nil" do
      let(:object) { nil }

      it { is_expected.to eq "Nil" }
    end

    context "with model_name" do
      context "when on class and instance" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_singleton_method(:model_name) { :model_name_from_class }
            klass.define_method(:model_name) { :model_name_from_instance }
          end
        end

        context "with class" do
          let(:object) { object_class }

          it { is_expected.to eq :model_name_from_class }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :model_name_from_instance }
        end
      end

      context "when only on instance" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_method(:model_name) { :model_name_from_instance }
          end
        end

        context "with class" do
          let(:object) { object_class }

          # This case is covered elsewhere; it's not actually `nil` unless you give it an unnamed anonymous class
          it { is_expected.to be_nil }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :model_name_from_instance }
        end
      end

      context "when only on class" do
        let(:object_class) do
          Class.new.tap do |klass|
            klass.define_singleton_method(:model_name) { :model_name_from_class }
          end
        end

        context "with class" do
          let(:object) { object_class }

          it { is_expected.to eq :model_name_from_class }
        end

        context "with instance" do
          let(:object) { object_class.new }

          it { is_expected.to eq :model_name_from_class }
        end
      end
    end

    context "when class" do
      let(:object) { Class.new }

      let(:object_class_name) { Faker::Lorem.words(2).join("_").camelize }

      before { stub_const(object_class_name, object) }

      it { is_expected.to eq object_class_name }
    end

    context "when symbol" do
      let(:object) { symbol }

      let(:symbol) { Faker::Lorem.words(2).join("_").to_sym }

      it { is_expected.to eq symbol.to_s.camelize }
    end

    context "when instance" do
      let(:object) { object_class.new }

      let(:object_class) { Class.new }
      let(:root_class_name) { Faker::Lorem.words(2).join("_").camelize }

      before { stub_const(object_class_name, object_class) }

      context "with Class suffix" do
        let(:object_class_name) { "#{root_class_name}Class" }

        it { is_expected.to eq root_class_name }
      end

      context "without suffix" do
        let(:object_class_name) { root_class_name }

        it { is_expected.to eq root_class_name }
      end
    end
  end
end

# frozen_string_literal: true

require_relative "./spec_helper"

RSpec.describe ShortCircuIt do
  it_behaves_like "a versioned spicerack gem"

  describe ".memoize" do
    let(:base_class) { Class.new.tap { |klass| klass.include described_class } }
    let(:define_methods_proc) do
      lambda do |spec_context|
        define_method spec_context.memoized_method_without_args do
          expensive_method(rand(100))
        end

        define_method spec_context.memoized_method_with_args do |*args|
          expensive_method(args.first)
        end

        define_method spec_context.memoized_method_with_block do |&block|
          block.call
        end

        define_method :expensive_method do |nth|
          last_value = 0
          current_value = 1

          nth.times do
            next_value = last_value + current_value
            last_value = current_value
            current_value = next_value
          end

          current_value
        end

        define_method :observed_value_one do
          @observed_value_one ||= 1
        end

        define_method :observed_value_two do
          @observed_value_two ||= 2
        end
      end
    end

    let(:memoized_method_with_args) { :method_with_arguments }
    let(:memoized_method_without_args) { :method_without_arguments }
    let(:memoized_method_with_block) { :method_with_block }
    let(:memoized_methods) { [ memoized_method_with_args, memoized_method_without_args, memoized_method_with_block ] }

    let(:all_observer_methods) { %i[observed_value_one observed_value_two] }

    let(:target_change) { nil }
    let(:argument_change) { nil }
    let(:memoization_options) { { observes: observes } }

    before do
      stub_const("BaseClass", base_class)
      stub_const("TargetClass", target_class)

      base_class.instance_exec(self, &define_methods_proc)

      allow(target_instance).to receive(:expensive_method).and_call_original
    end

    shared_context "when it observes nothing" do
      let(:observes) { nil }
    end

    shared_context "when it observes itself" do
      let(:observes) { :itself }
    end

    shared_context "when it observes one method" do
      let(:observed_method) { all_observer_methods.sample }
      let(:observes) { observed_method }
    end

    shared_context "when it observes multiple methods" do
      let(:observed_methods) { all_observer_methods }
      let(:observes) { observed_methods }
    end

    shared_context "when hash changes" do
      let(:target_change) { allow(target_instance).to receive(:hash).and_return(target_instance.hash + 1) }
    end

    shared_context "when observed method changes" do
      let(:target_change) do
        allow(target_instance).
          to receive(observed_method).
          and_return(target_instance.public_send(observed_method).hash + 1)
      end
    end

    shared_context "when one of the observed methods changes" do
      let(:changed_method) { observed_methods.sample }
      let(:target_change) do
        allow(target_instance).
          to receive(changed_method).
          and_return(target_instance.public_send(changed_method) + 1)
      end
    end

    shared_context "when both observed methods change" do
      let(:target_change) do
        observed_methods.each do |changed_method|
          allow(target_instance).
            to receive(changed_method).
            and_return(target_instance.public_send(changed_method) + 1)
        end
      end
    end

    shared_examples_for "a memoized value" do
      let!(:initial_value) { target_instance.public_send(memoized_method, *arguments, &block) }

      it "memoizes the value" do
        target_change
        argument_change
        expect(target_instance.public_send(memoized_method, *arguments, &block)).to eq initial_value
        expect(target_instance).to have_received(:expensive_method).exactly(:once)
      end
    end

    shared_examples_for "a new value" do
      let!(:initial_value) { target_instance.public_send(memoized_method, *arguments, &block) }

      it "gets a new value" do
        target_change
        argument_change
        target_instance.public_send(memoized_method, *arguments, &block)
        expect(target_instance).to have_received(:expensive_method).twice
      end
    end

    shared_examples_for "a method that observes nothing" do |with_memoization|
      include_context "when it observes nothing"

      context "when the instance does not change" do
        it_behaves_like(with_memoization ? "a memoized value" : "a new value")
      end

      context "when the instance changes between calls" do
        include_context "when hash changes"

        it_behaves_like(with_memoization ? "a memoized value" : "a new value")
      end
    end

    shared_examples_for "a method that observes one method" do |with_memoization|
      context "when the method observes one method" do
        include_context "when it observes one method"

        context "when the observed method does not change" do
          it_behaves_like(with_memoization ? "a memoized value" : "a new value")
        end

        context "when the observed method changes between calls" do
          include_context "when observed method changes"
          it_behaves_like "a new value"
        end
      end
    end

    shared_examples_for "a method that observes self" do |with_memoization|
      include_context "when it observes itself"

      context "when the instance does not change" do
        it_behaves_like(with_memoization ? "a memoized value" : "a new value")
      end

      context "when the instance changes between calls" do
        include_context "when hash changes"
        it_behaves_like "a new value"
      end
    end

    shared_examples_for "a method that observes multiple methods" do |with_memoization|
      include_context "when it observes multiple methods"

      context "when neither observed method changes" do
        it_behaves_like(with_memoization ? "a memoized value" : "a new value")
      end

      context "when one observed method changes" do
        include_context "when one of the observed methods changes"
        it_behaves_like "a new value"
      end

      context "when both observed methods change" do
        include_context "when both observed methods change"
        it_behaves_like "a new value"
      end
    end

    shared_examples_for "a method that takes no arguments" do |with_memoization: true|
      let(:arguments) { [] }
      let(:block) { nil }

      context "when the method observes nothing" do
        it_behaves_like "a method that observes nothing", with_memoization
      end

      context "when the method observes self" do
        it_behaves_like "a method that observes self", with_memoization
      end

      context "when the method observes one method" do
        it_behaves_like "a method that observes one method", with_memoization
      end

      context "when the method observes multiple methods" do
        it_behaves_like "a method that observes multiple methods", with_memoization
      end
    end

    shared_examples_for "a method that takes arguments" do |with_memoization: true|
      let(:arguments) { Array(rand(1..4)) { rand(100) } }
      let(:block) { nil }

      context "when arguments do NOT change between calls" do
        context "when the method observes nothing" do
          it_behaves_like "a method that observes nothing", with_memoization
        end

        context "when the method observes self" do
          it_behaves_like "a method that observes self", with_memoization
        end

        context "when the method observes one method" do
          it_behaves_like "a method that observes one method", with_memoization
        end

        context "when the method observes multiple methods" do
          it_behaves_like "a method that observes multiple methods", with_memoization
        end
      end
    end

    shared_examples_for "a method that takes a block" do |with_memoization: true|
      let(:arguments) { [] }
      let(:block) { -> { rand 100 } }

      context "when arguments do NOT change between calls" do
        context "when the method observes nothing" do
          it_behaves_like "a method that observes nothing", with_memoization
        end

        context "when the method observes self" do
          it_behaves_like "a method that observes self", with_memoization
        end

        context "when the method observes one method" do
          it_behaves_like "a method that observes one method", with_memoization
        end

        context "when the method observes multiple methods" do
          it_behaves_like "a method that observes multiple methods", with_memoization
        end
      end

      context "when arguments change between calls" do
        let(:argument_change) { arguments.push(arguments.shift + 1) }

        context "when the method observes nothing" do
          include_context "when it observes nothing"

          context "when the instance does not change" do
            it_behaves_like "a new value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes self" do
          include_context "when it observes itself"

          context "when the instance does not change" do
            it_behaves_like "a new value"
          end

          context "when the instance changes between calls" do
            include_context "when hash changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes one method" do
          include_context "when it observes one method"

          context "when the observed method does not change" do
            it_behaves_like "a new value"
          end

          context "when the observed method changes between calls" do
            include_context "when observed method changes"
            it_behaves_like "a new value"
          end
        end

        context "when the method observes multiple methods" do
          include_context "when it observes multiple methods"

          context "when neither observed method changes" do
            it_behaves_like "a new value"
          end

          context "when one observed method changes" do
            include_context "when one of the observed methods changes"
            it_behaves_like "a new value"
          end

          context "when both observed methods change" do
            include_context "when both observed methods change"
            it_behaves_like "a new value"
          end
        end
      end
    end

    shared_examples_for "a class with memoized methods" do
      context "when the method takes no arguments" do
        let(:memoized_method) { memoized_method_without_args }

        it_behaves_like "a method that takes no arguments", with_memoization: true
      end

      context "when the method takes arguments" do
        let(:memoized_method) { memoized_method_with_args }

        it_behaves_like "a method that takes arguments", with_memoization: true
      end

      context "when the method takes a block" do
        let(:memoized_method) { memoized_method_with_args }

        it_behaves_like "a method that takes a block", with_memoization: true
      end

      context "when the method is memoized in a parent class" do
        let(:target_class) { Class.new(base_class) }

        context "when the method takes no arguments" do
          let(:memoized_method) { memoized_method_without_args }

          it_behaves_like "a method that takes no arguments", with_memoization: true
        end

        context "when the method takes arguments" do
          let(:memoized_method) { memoized_method_with_args }

          it_behaves_like "a method that takes arguments", with_memoization: true
        end

        context "when the method is re-defined in the child class" do
          before do
            target_class.__send__(:define_method, :method_without_arguments) do
              expensive_method(rand(100))
            end

            target_class.__send__(:define_method, :method_with_arguments) do |*args|
              expensive_method(args.first)
            end
          end

          context "when the method takes no arguments" do
            let(:memoized_method) { memoized_method_without_args }

            it_behaves_like "a method that takes no arguments", with_memoization: false
          end

          context "when the method takes arguments" do
            let(:memoized_method) { memoized_method_with_args }

            it_behaves_like "a method that takes arguments", with_memoization: false
          end
        end
      end
    end

    context "when the memoization target is an instance" do
      let(:target_class) { base_class }
      let(:memoized_class) { base_class }
      let(:target_instance) { target_class.new }

      context "when only one method is memoized at a time" do
        before { memoized_class.__send__(:memoize, memoized_method, **memoization_options) }

        it_behaves_like "a class with memoized methods"
      end

      context "when multiple methods are memoized at a time" do
        before { memoized_class.__send__(:memoize, *memoized_methods, **memoization_options) }

        it_behaves_like "a class with memoized methods"
      end

      context "when the method is memoized in the parent class after the child class is defined" do
        let(:target_class) do
          Class.new(base_class) do
            def inconsequential_method; end
            memoize :inconsequential_method
          end
        end

        before do
          memoized_class.__send__(:memoize, memoized_method, **memoization_options)
        end

        it_behaves_like "a class with memoized methods"
      end
    end
  end
end

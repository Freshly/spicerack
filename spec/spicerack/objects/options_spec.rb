# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Options, type: :module do
  include_context "with an example input object"

  describe ".option" do
    it_behaves_like "an input object with a class collection attribute", :option, :_options

    context "with output option" do
      subject(:define_output) { example_input_object_class.__send__(:option, option, output: output) }

      let(:option) { Faker::Lorem.word.to_sym }

      context "when _outputs is defined" do
        before { example_input_object_class.__send__(:class_attribute, :_outputs, instance_writer: false, default: []) }

        context "with output:true" do
          let(:output) { true }

          it "adds to _outputs" do
            expect { define_output }.to change { example_input_object_class._outputs }.from([]).to([option])
          end
        end

        context "with output:false" do
          let(:output) { false }

          it "does not add to _outputs" do
            expect { define_output }.to_not change { example_input_object_class._outputs }.from([])
          end
        end
      end

      context "when _outputs is undefined and with output:true" do
        let(:output) { true }

        it "does not raise undefined error" do
          expect { define_output }.to_not raise_error
        end
      end
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :option do
      let(:root_class) { example_input_object_class }
    end
  end

  describe ".after_initialize" do
    before do
      example_input_object_class.__send__(:option, :test_option1, default: :default_value1)
      example_input_object_class.__send__(:option, :test_option2) { :default_value2 }
    end

    it_behaves_like "a class with attributes having default values" do
      subject(:instance) { example_input_object }

      let(:input) { key_values }
    end
  end
end

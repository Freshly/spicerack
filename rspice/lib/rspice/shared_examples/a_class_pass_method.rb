# frozen_string_literal: true

# RSpec example that tests class methods which take arguments that instantiate and call instance method of the same name
#
#     class Klass
#       # You can just call `Klass.do_something_extraordinary!(...)`! So convenient!!
#       def self.do_something_extraordinary!(named_argument, *arguments, **options)
#         new(named_argument, *arguments, **options).do_something_extraordinary!
#       end
#
#       attr_reader :some, :instance, :params
#
#       def initialize(named_argument, *arguments, **options)
#         @some = named_argument
#         @instance = arguments
#         @params = options
#       end
#
#       def do_something_extraordinary!
#         # Important things happen here
#       end
#     end
#
#     RSpec.describe Klass do
#       describe ".do_something_extraordinary!" do
#         it_behaves_like "a class pass method", :do_something_extraordinary!
#       end
#
#       describe "#do_something_extraordinary!" do
#         it "does something important"
#       end
#     end

RSpec.shared_examples_for "a class pass method" do |method|
  subject do
    if accepts_block?
      call_class.public_send(method, *arguments, **options, &block)
    else
      call_class.public_send(method, *arguments, **options)
    end
  end

  let(:call_class) { test_class }
  let(:test_class) { described_class }

  let(:method_parameters) { test_class.instance_method(:initialize).parameters }
  let(:argument_arity) { method_parameters.map(&:first).select { |type| type.in?(%i[req opt]) }.length }
  let(:option_keys) { method_parameters.select { |param| param.first.in?(%i[key keyreq]) }.map(&:last) }
  let(:accepts_block?) { method_parameters.any? { |param| param.first == :block } }

  let(:arguments) { Array.new(argument_arity) { double } }
  let(:options) { option_keys.each_with_object({}) { |key, hash| hash[key] = Faker::Lorem.word } }
  let(:block) { -> {} }
  let(:instance) { instance_double(test_class) }
  let(:output) { double }

  before do
    allow(instance).to receive(method).and_return(output)

    if accepts_block?
      allow(test_class).to receive(:new).with(*arguments, **options, &block).and_return(instance)
    elsif arguments.any? || options.any?
      allow(test_class).to receive(:new).with(*arguments, **options).and_return(instance)
    else
      allow(test_class).to receive(:new).with(no_args).and_return(instance)
    end
  end

  it { is_expected.to eq output }
end

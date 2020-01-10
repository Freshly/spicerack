# frozen_string_literal: true

RSpec.shared_context "with an example prototype" do
  subject(:example_prototype) { example_prototype_class.new }

  let(:example_prototype_class) do
    Class.new.tap { |klass| klass.include Conjunction::Prototype }
  end

  let(:example_prototype_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_prototype_name, example_prototype_class) }
end

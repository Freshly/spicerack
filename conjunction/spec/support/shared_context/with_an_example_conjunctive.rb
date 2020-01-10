# frozen_string_literal: true

RSpec.shared_context "with an example conjunctive" do
  subject(:example_conjunctive) { example_conjunctive_class.new }

  let(:example_conjunctive_class) do
    Class.new.tap { |klass| klass.include Conjunction::Conjunctive }
  end

  let(:example_conjunctive_name) { Faker::Internet.domain_word.capitalize }

  before { stub_const(example_conjunctive_name, example_conjunctive_class) }
end

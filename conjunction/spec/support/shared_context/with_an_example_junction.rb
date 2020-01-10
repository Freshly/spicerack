# frozen_string_literal: true

RSpec.shared_context "with an example junction" do
  subject(:example_junction) { example_junction_class.new }

  let(:example_junction_class) do
    Class.new.tap do |klass|
      klass.include Conjunction::Junction
      klass.__send__(:prefixed_with, prefix)
      klass.__send__(:suffixed_with, suffix)
    end
  end

  let(:prefix) { Faker::Internet.domain_word.capitalize }
  let(:suffix) { Faker::Internet.domain_word.capitalize }
  let(:prototype_name) { Faker::Internet.domain_word.capitalize }
  let(:example_junction_name) { [ prefix, prototype_name, suffix ].compact.join }

  before { stub_const(example_junction_name, example_junction_class) }
end

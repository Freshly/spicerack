# frozen_string_literal: true

RSpec.shared_context "with an example naming convention" do
  subject(:example_naming_convention) { example_naming_convention_class.new }

  let(:example_naming_convention_class) do
    Class.new.tap do |klass|
      klass.include Conjunction::NamingConvention
      klass.__send__(:prefixed_with, prefix)
      klass.__send__(:suffixed_with, suffix)
    end
  end

  let(:prefix) { Faker::Internet.domain_word.capitalize }
  let(:suffix) { Faker::Internet.domain_word.capitalize }
end

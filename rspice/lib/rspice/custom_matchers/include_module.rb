# frozen_string_literal: true

# RSpec matcher that tests usages of [Module#include](https://apidock.com/ruby/Module/include)
#
#     module Nodule; end
#     class Klass
#       include Nodule
#     end
#
#     RSpec.describe Klass do
#       it { is_expected.to include_module Nodule }
#     end

RSpec::Matchers.define :include_module do |expected_module|
  attr_reader :target

  description { "included the module #{expected_module}" }
  failure_message { |described_class| "expected #{described_class} to include module #{expected_module}" }
  failure_message_when_negated { |described_class| "expected #{described_class} not to include module #{expected_module}" }

  match do |target|
    @target = target

    test_subject.included_modules.include? expected_module
  end

  def test_subject
    target.is_a?(Module) ? target : target.class
  end
end

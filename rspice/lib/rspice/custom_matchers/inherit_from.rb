# frozen_string_literal: true

# RSpec matcher that tests inheritance of [Classes](https://apidock.com/ruby/Class)
#
#     class Klass < ApplicationRecord; end
#
#     RSpec.describe Klass do
#       it { is_expected.to inherit_from ApplicationRecord }
#     end

RSpec::Matchers.define :inherit_from do |superclass|
  match { test_subject.ancestors.include? superclass }
  description { "inherit from #{superclass}" }
  failure_message { "expected #{described_class.name} to inherit from #{superclass}" }
  failure_message_when_negated { "expected #{described_class.name} not to inherit from #{superclass}" }

  def test_subject
    subject.is_a?(Module) ? subject : subject.class
  end
end

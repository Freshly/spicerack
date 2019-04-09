# frozen_string_literal: true

# RSpec matcher for extend module.
#
# Usage:
#
# RSpec.describe User, type: :model do
#   subject { described_class }
#
#   it { is_expected.to extend_module Authenticatable }
# end

RSpec::Matchers.define :extend_module do |module_class|
  match { test_subject.singleton_class.included_modules.include? module_class }
  description { "extended the module #{module_class}" }
  failure_message { |described_class| "expected #{described_class} to extend module #{module_class}" }
  failure_message_when_negated { |described_class| "expected #{described_class} not to extend module #{module_class}" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end

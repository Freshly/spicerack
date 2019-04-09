# frozen_string_literal: true

# RSpec matcher to spec method aliases.
#
# Usage:
#
# RSpec.describe User, type: :model do
#   subject { described_class.new }
#
#   it { is_expected.to alias_method :alias_name, :target_name }
# end

RSpec::Matchers.define :alias_method do |alias_name, target_name|
  match do |instance|
    instance.method(alias_name) == instance.method(target_name)
  end

  description do
    "aliases #{target_name} as #{alias_name}"
  end

  failure_message do |instance|
    "expected #{instance.class.name}##{alias_name} to be an alias of #{target_name}"
  end

  failure_message_when_negated do |instance|
    "expected #{instance.class.name}##{alias_name} to not be an alias of #{target_name}"
  end
end

# frozen_string_literal: true

RSpec::Matchers.define :have_attr_writer do |field|
  match do |object_instance|
    object_instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected attr_reader for #{field} on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_reader for #{field} not to be defined on #{object_instance}"
  end

  description do |_object_instance|
    "have attr_reader for #{field}"
  end
end

# frozen_string_literal: true

require "active_support/core_ext/hash/keys"

# RSpec matcher to assert the definition of a thread accessor
#
#     class MyClass
#       include Tablesalt::ThreadAccessor
#
#       thread_writer :foo, :a_foo_key
#     end
#
#     RSpec.describe MyClass do
#       subject { described_class }
#
#       it { is_expected.to define_thread_writer :foo, :a_foo_key, private: false }
#     end
RSpec::Matchers.define :define_thread_writer do |writer_name, thread_key, **options|
  attr_reader :subject, :writer_name, :method_name, :thread_key, :private_opt, :namespace

  description { "define#{a_private} thread writer #{writer_name.inspect} with thread key #{thread_key.inspect}#{namespace_failure_message}" }

  failure_message { "expected #{subject_module} to define#{a_private} thread writer #{writer_name.inspect} with thread key #{thread_key.inspect}#{namespace_failure_message}" }
  failure_message_when_negated { "expected #{subject_module} not to define#{a_private} thread writer #{writer_name.inspect} with thread key #{thread_key.inspect}#{namespace_failure_message}" }

  match do |subject|
    options.assert_valid_keys(:private, :namespace)

    @subject = subject
    @writer_name = writer_name
    @method_name = "#{writer_name}="
    @thread_key = thread_key.to_sym
    @private_opt = options.fetch(:private, true)
    @namespace = options.fetch(:namespace, nil)

    expect(instance).to be_respond_to(method_name, true)
    expect(klass).to be_respond_to(method_name, true)

    klass.__send__(method_name, class_stubbed_value)
    expect(Tablesalt::ThreadAccessor.store(namespace)[thread_key]).to eq class_stubbed_value

    instance.__send__(method_name, instance_stubbed_value)
    expect(Tablesalt::ThreadAccessor.store(namespace)[thread_key]).to eq instance_stubbed_value

    if private_opt
      expect(klass).to be_private_method_defined method_name
      expect(klass.singleton_class).to be_private_method_defined method_name
    end

    true
  end

  private

  def subject_module
    subject.is_a?(Module) ? subject : subject.class
  end

  def klass
    @klass ||= subject.is_a?(Module) ? subject : subject.class
  end

  def instance
    return subject unless subject.is_a?(Module)
    return subject unless subject.respond_to?(:new)

    @instance ||= begin
      allow(klass).to receive(:initialize).with(any_args)
      subject.new
    end
  end

  def class_stubbed_value
    @class_stubbed_value ||= double("class thread value")
  end

  def instance_stubbed_value
    @instance_stubbed_value ||= double("instance thread value")
  end

  def a_private
    return unless private_opt

    " a private"
  end

  def namespace_failure_message
    return if namespace.blank?

    " in #{namespace.inspect} namespace"
  end
end

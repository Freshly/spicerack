# frozen_string_literal: true

require "active_support/core_ext/hash/keys"

# RSpec matcher to assert the definition of a thread accessor
#
#     class MyClass
#       include Tablesalt::ConfigDelegation
#
#       thread_reader :a_thread_key
#     end
#
#     RSpec.describe MyClass do
#       subject { described_class }
#
#       it { is_expected.to define_thread_reader :a_thread_key, private: false }
#     end
RSpec::Matchers.define :define_thread_reader do |method_name, thread_key, **options|
  attr_reader :subject, :method_name, :thread_key, :private_opt

  description { "defines#{a_private} thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }

  failure_message { "expected #{subject_module} to define#{a_private} thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }
  failure_message_when_negated { "expected #{subject_module} not to define#{a_private} thread reader #{method_name.inspect} with thread key #{thread_key.inspect}" }

  match_unless_raises do |subject|
    options.assert_valid_keys(:private)

    @subject = subject
    @method_name = method_name
    @thread_key = thread_key.to_sym
    @private_opt = options.fetch(:private, true)

    with_value_on_thread do
      expect(instance).to be_respond_to(method_name, true)
      expect(klass).to be_respond_to(method_name, true)

      expect(instance.__send__(method_name)).to eq stubbed_value
      expect(klass.__send__(method_name)).to eq stubbed_value

      if private_opt
        expect { instance.public_send(method_name) }.to raise_error NoMethodError
        expect { klass.public_send(method_name) }.to raise_error NoMethodError
      end
    end

    true
  end

  private

  def with_value_on_thread
    Tablesalt::ThreadAccessor.store[thread_key] = stubbed_value

    yield

    Tablesalt::ThreadAccessor.store[thread_key] = nil
  end

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

  def stubbed_value
    @stubbed_value ||= double("Thread value")
  end

  def a_private
    return unless private_opt

    " a private"
  end
end

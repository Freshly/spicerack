# frozen_string_literal: true

# RSpec matcher to assert the definition of a thread accessor
#
#     class MyClass
#       include Tablesalt::ThreadAccessor
#
#       thread_accessor :foo, :a_foo_key
#     end
#
#     RSpec.describe MyClass do
#       subject { described_class }
#
#       it { is_expected.to define_thread_accessor :foo, :a_foo_key, private: false }
#     end
RSpec::Matchers.define :define_thread_accessor do |accessor_name, thread_key, **options|
  match do |subject|
    expect(subject).to define_thread_reader accessor_name, thread_key, **options
    expect(subject).to define_thread_writer accessor_name, thread_key, **options
  end
end

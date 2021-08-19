# frozen_string_literal: true

# Required contexts:
#   method
#      - the symbol used for writing, that the receiver should respond to
#   thread_key
#      - the key the thread accessor actually uses under the hood
#   receiver
#      - the receiver of the accessor methods.
#   private?
#      - boolean, true if the method is expected to be private. Default: true
RSpec.shared_examples "a thread writer" do
  subject { receiver }

  let(:method_name) { "#{method}=" }
  let(:value) { double }
  let(:namespace) {}
  let(:private?) { true }

  before { receiver.__send__(method_name, value) }

  it { is_expected.to define_thread_writer method, thread_key, namespace: namespace, private: private? }

  it "writes to the thread store" do
    expect(Tablesalt::ThreadAccessor.store(namespace)[thread_key]).to eq value
  end

  it "has expected privacy" do
    klass = receiver.is_a?(Module) ? receiver : receiver.class

    if private?
      expect(klass).to be_private_method_defined method_name
    else
      expect(klass).not_to be_private_method_defined method_name
    end
  end
end

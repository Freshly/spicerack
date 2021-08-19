# frozen_string_literal: true

# Required contexts:
#   method
#      - the symbol used for getting and setting, that the receiver should respond to
#   thread_key
#      - the key the thread accessor actually uses under the hood
#   receiver
#      - Required; the receiver of the accessor methods.
#   private?
#      - Optional, boolean; true if the method is expected to be private. Default: true
#   namespace
#      - Optional; the namespace for the thread store. Default: nil
RSpec.shared_examples "a thread accessor" do
  subject { receiver }

  let(:namespace) { nil }

  it_behaves_like "a thread reader"
  it_behaves_like "a thread writer"

  it { is_expected.to define_thread_accessor method, thread_key, private: private?, namespace: namespace }
end

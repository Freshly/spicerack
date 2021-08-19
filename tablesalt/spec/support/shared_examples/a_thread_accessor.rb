# frozen_string_literal: true

# Required contexts:
#   method
#      - the symbol used for getting and setting, that the receiver should respond to
#   thread_key
#      - the key the thread accessor actually uses under the hood
#   receiver
#      - the receiver of the accessor methods.
#   private?
#      - boolean, true if the method is expected to be private
RSpec.shared_examples "a thread accessor" do
  it_behaves_like "a thread reader"
  it_behaves_like "a thread writer"
end

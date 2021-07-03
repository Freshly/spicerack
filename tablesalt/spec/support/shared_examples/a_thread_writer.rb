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
  subject(:write) { Thread.current[thread_key] }

  let(:method_name) { "#{method}=" }
  let(:value) { double }
  let(:private?) { true }

  before { receiver.__send__(method_name, value) }

  it { is_expected.to eq value }

  it "has expected privacy" do
    if private?
      expect { receiver.public_send(method_name, value) }.to raise_error(NoMethodError)
    else
      expect { receiver.public_send(method_name, value) }.not_to raise_error
    end
  end

  it "tracks the written variable" do
    write
    expect(Thread.current[Tablesalt::ThreadAccessor::WRITTEN_VARIABLES_THREAD_KEY]).to eq Set.new([ thread_key ])
  end
end

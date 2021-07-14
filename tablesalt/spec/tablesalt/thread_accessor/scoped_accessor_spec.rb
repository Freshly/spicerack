# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor::ScopedAccessor do
  subject(:mod) { described_class.new(scope) }

  let(:scope) { Faker::Lorem.words.join("-").underscore }
  let(:example_class) do
    Class.new.tap do |klass|
      klass.instance_exec(self) do |spec|
        include spec.mod
      end
    end
  end

  it { is_expected.to extend_module ActiveSupport::Concern }
  it { is_expected.to extend_module Tablesalt::ThreadAccessor::Management }

  context "when included by a class" do
    subject { example_class }

    it { is_expected.to include_module mod }
    it { is_expected.to include_module Tablesalt::ThreadAccessor }
  end

  describe "#name" do
    subject { mod.name }

    it { is_expected.to eq "#{described_class}:#{scope}"}
  end

  describe "#inspeect" do
    subject { mod.inspect }

    it { is_expected.to eq "#<#{mod.name}>" }
  end
end

# frozen_string_literal: true

require "spec_helper"
require "generators/stenotype/initializer/initializer_generator"

RSpec.describe Stenotype::Generators::InitializerGenerator, type: :generator do
  setup_default_destination

  describe "#create_initializer" do
    before { run_generator %w[stenotype:initializer] }

    subject(:config_file_path) { file("config/initializers/stenotype.rb") }

    it "exists" do
      expect(File).to exist(config_file_path)
    end

    it "contains Rails.application.configure" do
      expect(File.read(config_file_path)).to match(%r{Rails.application.configure})
    end

    it "contains # config.stenotype" do
      expect(File.read(config_file_path)).to match(%r{# config.stenotype})
    end
  end
end

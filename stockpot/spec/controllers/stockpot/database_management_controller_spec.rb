# frozen_string_literal: true

require "rails_helper"

RSpec.describe Stockpot::DatabaseManagementController, type: :controller do
  describe "GET #records" do
    it "returns existing records" do
      get :records
      puts response
      expect(response).to eq "foo"
    end
  end
end

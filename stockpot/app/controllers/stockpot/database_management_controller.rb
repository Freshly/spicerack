# frozen_string_literal: true

require_dependency "stockpot/application_controller"

module Stockpot
  class DatabaseManagementController < ApplicationController
    def records
      render json: { "stockpot": "get_records" }.to_json, status: :ok
    end

    def create
      render json: { "stockpot": "create_factory" }.to_json, status: :ok
    end

    def delete
      render json: { "stockpot": "delete_records" }.to_json, status: :ok
    end

    def update
      render json: { "stockpot": "update_records" }.to_json, status: :ok
    end
  end
end

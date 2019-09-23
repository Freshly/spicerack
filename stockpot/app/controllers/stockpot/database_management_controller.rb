require_dependency "stockpot/application_controller"

module Stockpot
  class DatabaseManagementController < ApplicationController
    def index
      render json: {"stockpot": "hello"}.to_json, status: :ok
    end
  end
end

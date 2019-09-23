# frozen_string_literal: true

Stockpot::Engine.routes.draw do
  post "/records", to: "database_management#create"
  get "/records", to: "database_management#records"
  delete "/records", to: "database_management#delete"
  put "/records", to: "database_management#update"
end

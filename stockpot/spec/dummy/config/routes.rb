# frozen_string_literal: true

Rails.application.routes.draw do
  mount Stockpot::Engine => "/stockpot"
end

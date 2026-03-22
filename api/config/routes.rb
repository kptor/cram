require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, path: "api/v1/users"

  post "/graphql", to: "graphql#execute"

  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  get "up" => "rails/health#show", as: :rails_health_check
end

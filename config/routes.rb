Rails.application.routes.draw do
  resources :leftovers
  resource "logins", only: [:new, :destroy] do
    post :google
  end

  resources :recipes
  resource :menu_plan, only: %i[new edit] do
    member do
      post :update_number_of_days
      post :fill_recipes
    end
  end
  resources :plan_days
  resources :tags

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static#root"
end

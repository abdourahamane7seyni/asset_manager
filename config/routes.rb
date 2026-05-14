Rails.application.routes.draw do
  devise_for :users
  root to: "dashboard#index"
  resource :profile, only: [:show, :update], controller: "profile"

  resources :employees do
    member do
      get :decharge
      post :envoyer_decharge
      patch :update_statut_decharge
    end
  end

  resources :materiels do
    get :qrcode, on: :member
  end

  resources :movements
  get "up" => "rails/health#show", as: :rails_health_check
end

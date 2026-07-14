Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "signup", to: "registrations#create"
      post "login", to: "sessions#create"

      resources :artists, only: [ :index, :show ] do
        member do
          post :follow, to: "follows#create"
          delete :follow, to: "follows#destroy"
        end
      end

      resources :albums, only: [ :index, :show ]

      resources :tracks, only: [ :index, :show ] do
        member do
          post :play, to: "plays#create"
          post :like, to: "likes#create"
          delete :like, to: "likes#destroy"
        end
      end

      resources :playlists do
        resources :tracks, only: [ :create, :update, :destroy ], controller: "playlist_tracks"
      end
    end
  end
end

Rails.application.routes.draw do

  namespace :api, defaults: { format: :json}, path: '/api' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :sessions, only: [:create]
      delete '/sessions', to: 'sessions#destroy'

      resources :habits, only: [:create] do
        collection do
          get :current
        end

        member do
          post :mark
          post :fail
        end
      end
    end
  end

  root "home#welcome"

end

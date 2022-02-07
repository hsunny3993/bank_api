Rails.application.routes.draw do
  apipie
  post 'authenticate', to: 'authentication#auth'

  namespace :api do
    namespace :v1 do
      resources :transactions, only: [:index, :show]
      resources :accounts, only: [:balance, :deposit, :withdraw, :transfer, :show] do
        collection do
          get :show
          get :balance
          post :deposit
          post :withdraw
          post :transfer
        end
      end
      resources :customers, only: [:index, :show, :create, :update, :destroy]
    end
  end
end

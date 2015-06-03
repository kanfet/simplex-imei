Rails.application.routes.draw do

  resources :devices, only: [:index] do
    get :search, on: :collection
  end

  root to: 'devices#index'

end

Rails.application.routes.draw do
  resources :mpays

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:index, :show]
  resources :posts, only: [:index, :show]

  post 'sign_up', to: 'users#sign_up'
  post 'log_in', to: 'auth#log_in'
  post 'create_post', to: 'posts#create_post'
  post 'stkpush', to: 'mpays#stkpush'
  post 'polling_payment', to: 'mpesa#polling_payment'
end

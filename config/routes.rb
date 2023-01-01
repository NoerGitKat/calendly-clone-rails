require 'sidekiq/web'

Rails.application.routes.draw do
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end


  devise_for :users

  authenticated :user do
    root to: "home#dashboard", as: :authenticated_root
  end

  resources :meetings
  resources :bookings, except: [:index, :new]

  post "payment-intent", to: "bookings#intent"
  get ":booking_link", to: "users#show", as: :user

  scope '/:booking_link', as: :user do
    resources :bookings, only: [:index, :new]
  end
  
  root to: "home#index"
end

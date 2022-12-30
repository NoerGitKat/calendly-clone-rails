require 'sidekiq/web'

Rails.application.routes.draw do
  resources :meetings
  resources :bookings
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end


  devise_for :users

  authenticated :user do
    root to: "home#dashboard", as: :authenticated_root
  end
  
  root to: "home#index"
end

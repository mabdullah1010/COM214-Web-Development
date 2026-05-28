Rails.application.routes.draw do

  root 'static_pages#home'
  get '/home',    to: 'static_pages#home'
  get '/about',   to: 'static_pages#about'
  get '/help',    to: 'static_pages#help'

  resources :users do
    member do
      get 'documents', to: 'users#documents'
    end
  end
  get '/signup', to: 'users#new'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :documents do
    resources :comments, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check

end

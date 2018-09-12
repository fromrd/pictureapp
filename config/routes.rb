Rails.application.routes.draw do
  get 'sessions/new'

  root to: 'pictures#index'
  
  resources :sessions, only: [:new, :create, :destroy]

  resources :pictures do
    collection do
      post :confirm
      get :top
    end
  end
  
  resources :users, only: [:new, :create, :show]
  
  resources :favorites, only: [:create, :destroy]
  
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
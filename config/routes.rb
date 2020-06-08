Rails.application.routes.draw do

  root 'tickets#index'
  get '/register'  => 'users#new'

  resources :comments, only: [:new, :create]
  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end
  resources :users, except: [:new]
  resources :tickets do
    member do
      get :close_ticket, as: 'close'
      get :reopen_ticket, as: 'reopen'
    end
  end

  get "*path", to: "sessions#new"
end

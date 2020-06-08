Rails.application.routes.draw do

  root 'tickets#index'
  get '/register'  => 'users#new'

  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    get 'logout' => :destroy
  end
  resources :users
  resources :tickets do
    member do
      get :close_ticket, as: 'close'
      get :reopen_ticket, as: 'reopen'
    end
  end

  get "*path", to: "sessions#new"
end

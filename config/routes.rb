Rails.application.routes.draw do

  resources :user_tickets, only: :index
  root 'tickets#index'
  get '/register'  => 'users#new'

  resources :comments, only: [:new, :create]
  controller :sessions do
    get    'login'  => :new
    post   'login'  => :create
    delete 'logout' => :destroy
  end
  resources :users, except: [:new] do
    member do
      get :assign_ticket
      get :create_admin, as: 'admin'
      get :create_agent, as: 'agent'
      get :create_customer, as: 'customer'
    end
  end

  get 'tickets_report' => 'tickets'
  resources :tickets do
    member do
      get :close_ticket, as: 'close'
      get :reopen_ticket, as: 'reopen'
    end
  end

  get '*path', to: 'pages#page_not_found'
end

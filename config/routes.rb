Rails.application.routes.draw do
  resources :users
  resources :tickets do
    member do
      get :close_ticket, as: 'close'
      get :make_ticket_active, as: 'activate'
    end
  end
end

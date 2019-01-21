Rails.application.routes.draw do
  resources :comments
  resources :posts
  devise_for :users
  resources :users 

  post '/create_user', action: :create_user, controller: 'users'
  root "users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

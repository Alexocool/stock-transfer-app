Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'users#index'
  namespace :admin do
    resources :users, only: %i[index show]
  end
end

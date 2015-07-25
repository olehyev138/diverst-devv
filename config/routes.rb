Rails.application.routes.draw do
  devise_for :admins
  devise_for :employees

  resources :enterprises
  resources :employees
  resources :admins

  root to: "employees#index"
end

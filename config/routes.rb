Rails.application.routes.draw do
  devise_for :admins
  devise_for :employees, :controllers => { :invitations => 'employees/invitations' }

  resources :enterprises
  resources :employees
  resources :admins

  root to: "employees#index"
end

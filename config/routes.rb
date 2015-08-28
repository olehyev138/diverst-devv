Rails.application.routes.draw do
  devise_for :admins
  devise_for :employees, :controllers => { :invitations => 'employees/invitations' }

  resources :employees

  resources :enterprises do
    resources :saml do
      collection do
        get :sso
        post :acs
        get :metadata
        get :logout
      end
    end
  end

  resources :admins

  resources :matches do
    collection do
      get :test
      post :test, action: :score
    end
  end

  root to: "employees#index"
end

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :admins
  devise_for :employees, :controllers => { :invitations => 'employees/invitations' }

  namespace :employees, defaults: { format: :json } do
    mount_devise_token_auth_for 'Employee', at: 'auth'
  end

  resources :devices do
    member do
      post 'test_notif'
    end
  end

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

    member do
      get 'edit_auth'
      get 'edit_fields'
      get 'edit_algo'
      get 'edit_mobile_fields'
    end
  end

  resources :groups do
    scope module: :groups do
      resources :group_members, path: "members"
      resources :group_messages, path: "messages"
      resources :events
      resources :news_links
    end

    member do
      get 'join'
    end
  end

  scope :news_links do
    get 'url_info', to: "news_links#url_info"
  end

  resources :polls do
    resources :poll_responses, path: "responses" do
      member do
        get 'thank_you'
      end
    end

    resources :poll_fields, path: "fields" do
      member do
        get 'answer_popularities'
      end
    end
  end

  resources :segments

  resources :topics do
    resources :topic_feedbacks, path: "feedbacks" do
      collection do
        get 'thank_you'
      end
    end
  end

  resources :campaigns do
    member do
      resources :questions
    end
  end

  resources :admins

  devise_scope :employee do
    resources :matches do
      collection do
        get :test
        post :test, action: :score
      end

      member do
        put 'swipe'
      end
    end

    resources :conversations do
      member do
        put 'opt_in'
        put 'leave'
      end
    end
  end

  root to: "employees#index"
end
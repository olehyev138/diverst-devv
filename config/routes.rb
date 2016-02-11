Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, controllers: { invitations: 'users/invitations' }

  get 'omniauth/:provider/callback', to: 'omni_auth#callback'

  namespace :users, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth/token'
  end

  namespace :integrations do
    scope :yammer, as: :yammer do
      get 'login', to: 'yammer#login'
      get 'callback', to: 'yammer#callback'
      get 'configure', to: 'yammer#configure'
    end
  end

  resources :devices do
    member do
      post 'test_notif'
    end
  end

  resources :users do
    collection do
      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
    end
  end

  get 'integrations', to: 'integrations#index'

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
      get 'edit_mobile_fields'
      get 'edit_branding'
      get 'edit_algo'
      get 'theme'
      patch 'update_branding'
      patch 'restore_default_branding'
    end

    scope module: :enterprises do
      resources :resources
    end
  end

  resources :groups do
    scope module: :groups do
      resources :group_members, path: 'members'
      resources :group_messages, path: 'messages'
    end

    scope :groups, module: :groups do
      resources :events
      resources :news_links
      resources :resources
    end

    member do
      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
    end
  end

  resources :news_links, only: [] do
    collection do
      get 'url_info'
    end
  end

  resources :polls do
    member do
      get 'export_csv'
    end

    resources :poll_responses, path: 'responses' do
      member do
        get 'thank_you'
      end
    end

    resources :poll_fields do
      member do
        get 'answer_popularities'
      end
    end

    resources :graphs, only: [:new, :create]
  end

  resources :fields do
    member do
      get 'stats'
    end
  end

  resources :segments do
    member do
      get 'export_csv'
    end
  end

  resources :topics do
    resources :topic_feedbacks, path: 'feedbacks' do
      collection do
        get 'thank_you'
      end
    end
  end

  resources :campaigns do
    resources :questions, shallow: true do
      resources :answers, shallow: true do
        resources :answer_comments, path: 'comments', shallow: true
      end

      member do
        patch 'reopen'
      end
    end

    member do
      get 'contributions_per_erg'
      get 'top_performers'
    end
  end

  devise_scope :user do
    namespace :user do
      root to: 'dashboard#home'

      resources :news_links
      resources :messages
      resources :events
      resources :resources

      resources :campaigns, shallow: true do
        resources :questions, shallow: true do
          resources :answers, shallow: true do
            resources :answer_comments, shallow: true, path: 'comments'

            member do
              put 'vote'
            end
          end
        end
      end

      resources :groups do
        member do
          get 'join'
        end
      end

      resources :users
    end

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

  resources :metrics_dashboards do
    resources :graphs, shallow: true do
      member do
        get 'data'
      end
    end
  end

  resource :generic_graphs do
    get 'group_population'
    get 'segment_population'
    get 'events_created'
    get 'messages_sent'
  end

  namespace :website do
    resources :leads
  end

  resources :policy_groups
  resources :emails

  root to: 'metrics_dashboards#index'
end

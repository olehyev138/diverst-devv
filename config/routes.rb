Rails.application.routes.draw do
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_DASHBOARD_USERNAME"] && password == ENV["SIDEKIQ_DASHBOARD_PASSWORD"]
  end if Rails.env.production?
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
      get 'edit_profile'

      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
      get 'date_histogram'
    end
  end

  resources :biases

  resources :notifications, only: [:index]

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
      get 'edit_budgeting'
      get 'edit_auth'
      get 'edit_fields'
      get 'edit_mobile_fields'
      get 'edit_branding'
      get 'edit_algo'
      get 'theme'
      patch 'update_branding'
      patch 'restore_default_branding'
      get 'bias'
    end

    scope module: :enterprises do
      resources :resources
    end
  end

  get 'integrations', to: 'integrations#index'

  resources :groups do
    scope module: :groups do
      resources :group_members, path: 'members' do
        collection do
          get 'pending'
          post 'add_members'
        end
        member do
          post 'accept_pending'
          delete 'remove_member'
        end
      end
      resources :group_messages, path: 'messages' do
        post 'create_comment'
      end
    end

    scope module: :groups do
      resources :events do
        resource :attendance do
          get 'erg_graph'
          get 'segment_graph'
        end

        resources :comments

        collection do
          get 'calendar_view'
          get 'calendar_data'
        end

        member do
          get 'export_ics'
        end
      end

      resources :news_links do
        member do
          get 'comments'
          post 'create_comment'
        end
      end
      resources :resources
      resources :fields do
        member do
          get 'time_series'
        end
      end
      resources :updates
    end

    # Planning

    resources :outcomes
    resources :pillars
    resources :initiatives do
      scope module: 'initiatives' do
        resources :updates

        resources :expenses do
          collection do
            get 'time_series'
          end
        end

        resources :fields do
          member do
            get 'time_series'
          end
        end

        resources :resources
      end

      member do
        get 'todo'
        post 'finish_expenses'
      end
    end

    member do
      get 'settings'

      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
      get 'metrics'
      get 'edit_fields'
      get 'edit_annual_budget'
      post 'update_annual_budget'

      get 'budgets'


      #bTODO - move budgets to another controller
      get 'view_budget'
      get 'request_budget'
      post 'submit_budget'
      post 'approve_budget'
      post 'decline_budget'
    end

    collection do
      get 'plan_overview'
      get 'calendar'
      get 'calendar_data'
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

    collection do
      get 'metrics'
    end
  end

  resources :campaigns do
    resources :questions, shallow: true do
      resources :answers, shallow: true do
        resources :answer_comments, path: 'comments', shallow: true

        member do
          get 'breakdown'
        end
      end

      scope module: :questions do
        resource :roi, controller: "roi"
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

  resources :expenses
  resources :expense_categories

  devise_scope :user do
    namespace :user do
      root to: 'dashboard#home'

      get 'rewards', to: 'dashboard#rewards'
      get 'bias', to: 'dashboard#bias'

      resources :news_links
      resources :messages
      resources :events do
        collection do
          get 'calendar'
          get 'calendar_data'
          get 'onboarding_calendar_data'
        end
      end

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

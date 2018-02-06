Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_DASHBOARD_USERNAME"] && password == ENV["SIDEKIQ_DASHBOARD_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users, controllers: {
    invitations: 'users/invitations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  get 'users/invitation', to: 'users/invitations#index'

  get 'omniauth/:provider/callback', to: 'omni_auth#callback'
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users
      resources :groups
      resources :enterprises, :only => [:update] do
        member do
          get "events"
        end
      end
    end
  end

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
    member do
      get 'group_surveys'
      put 'resend_invitation'
    end

    collection do
      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
      get 'date_histogram'
      get 'sent_invitations'
      get 'saml_logins'
    end
  end

  resources :biases

  resources :logs, only: [:index]

  get 'integrations', to: 'integrations#index'
  get 'integrations/calendar/:token', to: 'integrations#calendar', as: 'integrations_calendar'

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
      get 'edit_pending_comments'
      get 'edit_algo'
      get 'theme'
      patch 'update_branding'
      patch 'restore_default_branding'
      get 'bias'
      patch 'delete_attachment'
      get 'calendar'
    end
    
    scope module: :enterprises do
      resources :folders do
        member do
          post 'authenticate'
        end
        scope module: :folder do
          resources :resources
        end
      end
      resources :resources
      resources :events, only: [] do
        collection do
          get 'public_calendar_data'
        end
      end
    end
  end

  get 'integrations', to: 'integrations#index'

  resources :groups do
    resources :budgets, only: [:index, :show, :new, :create, :destroy] do
      post 'approve'
      post 'decline'
      collection do
        get 'edit_annual_budget'
        post 'update_annual_budget'
        post 'reset_annual_budget'
        post 'carry_over_annual_budget'
      end
    end

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
        resources :group_message_comment
      end
      resources :leaders, only: [:index, :new, :create]
      resources :social_links
      resources :questions, only: [:index] do
        collection do
          get 'survey'
          post 'submit_survey'
          get 'export_csv'
        end
      end
    end

    scope module: :groups do
      resources :events do
        resource :attendance do
          get 'erg_graph'
          get 'segment_graph'
        end

        resources :comments, only: [:create, :destroy] do 
          member do 
            patch 'approve'
            patch 'disapprove'
          end
        end

        collection do
          get 'calendar_view'
          get 'calendar_data'
        end

        member do
          get 'export_ics'
        end
      end

      resources :user_groups, only: :update

      resources :news_links, except: [:show] do
        member do
          get   'comments'
          get   'news_link_photos'
          post  'create_comment'
        end
        resources :news_link_comment
      end
      resources :posts, :only => [:index] do
        collection do
          get 'pending'
          post 'approve'
        end
      end
      
      resources :folders do
        member do
          post 'authenticate'
        end
        scope module: :folder do
          resources :resources
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
        get 'attendees'
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
      patch 'delete_attachment'
    end

    collection do
      get 'plan_overview'
      get 'close_budgets'
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

    scope module: 'polls' do
      resources :graphs, only: [:new, :create, :edit]
    end
  end
  
  resources :graphs do
    member do
      get "data"
      get "export_csv"
    end
  end

  resources :fields do
    member do
      get 'stats'
    end
  end

  resources :rewards, except: [:show]
  resources :badges, except: [:index, :show]

  resources :reward_actions, only: [] do
    collection do
      patch 'update'
    end
  end

  resources :segments do
    resources :sub_segments
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
        resources :answer_comments, only: [:update, :destroy], path: 'comments', shallow: true

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
      get 'privacy_statement', to: 'dashboard#privacy_statement'
      get 'preferences/edit', to: 'user_groups#edit'
      patch 'preferences/update', to: 'user_groups#update'

      resources :social_links
      resources :news_links
      resources :messages
      resources :events do
        collection do
          get 'calendar'
          get 'onboarding_calendar_data'
        end
      end

      resources :resources

      resources :user_campaigns, shallow: true do
        resources :questions, shallow: true do
          resources :user_answers, shallow: true do
            resources :user_answer_comments, shallow: true, path: 'comments'
            member do
              put 'vote'
            end
          end
        end
      end

      resources :rewards, only: [] do
        resources :user_rewards, only: :create do
          collection do
            get :success
            get :error
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
    get 'shared_dashboard'

    resources :graphs do
      member do
        get 'data'
        get 'export_csv'
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

  resources :policy_groups do
    member do
      post 'add_users'
    end
  end
  resources :emails
  resources :custom_texts, only: [:edit, :update]
  
  match "*a", :to => "application#routing_error", :via => [:get, :post]

  root to: 'metrics_dashboards#index'
end

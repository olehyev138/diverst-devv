Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_DASHBOARD_USERNAME'] && password == ENV['SIDEKIQ_DASHBOARD_PASSWORD']
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    invitations: 'users/invitations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  get 'users/invitation', to: 'users/invitations#index'

  get 'omniauth/:provider/callback', to: 'omni_auth#callback', as: 'omniauth_callback'

  get 'tags', to: 'news_tags#tags_search'

  resources :onboarding, only: [:index]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users
      resources :groups
      resources :join_me
      resources :enterprises, only: [:update] do
        member do
          get 'events'
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

  resources :outlook, only: [:index]

  resources :user_roles
  resources :users do
    member do
      get 'show_usage'
      get 'user_url_usage_data'
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
      get 'users_points_ranking'
      get 'users_points_csv'
      get 'users_pending_rewards'
    end
  end

  resources :logs, only: [:index]

  get 'integrations', to: 'integrations#index'
  get 'integrations/calendar/:token', to: 'integrations#calendar', as: 'integrations_calendar'

  resources :archived_posts, only: [:index, :destroy] do
    collection do
      post 'delete_all'
      post 'restore_all'
    end

    member { patch 'restore' }
  end

  resources :archived_initiatives, only: [:index, :destroy] do
    collection do
      post 'delete_all'
      post 'restore_all'
    end

    member { patch 'restore' }
  end

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
      get 'edit_posts'
      get 'edit_algo'
      get 'theme'
      patch 'update_auth'
      patch 'update_fields'
      patch 'update_mapping'
      patch 'update_branding_info'
      patch 'update_branding'
      patch 'update_posts'
      patch 'restore_default_branding'
      get 'bias'
      patch 'delete_attachment'
      get 'calendar'
      patch 'auto_archive_switch'
    end

    scope module: :enterprises do
      resources :folders do
        member do
          post 'authenticate'
        end
        scope module: :folder do
          resources :resources do
            member do
              patch 'archive'
              patch 'restore'
            end
          end
        end
      end
      resources :resources do
        collection do
          get 'archived'
          post 'restore_all'
          post 'delete_all'
        end
      end
      resources :events, only: [] do
        collection do
          get 'public_calendar_data'
        end
      end
    end
  end

  resources :clockwork_database_events

  get 'integrations', to: 'integrations#index'

  resources :group_category_types, only: [:edit, :update, :destroy] do
    member do
      get 'add_category'
      post 'update_with_new_category'
    end
  end

  resources :group_categories do
    collection do
      get 'view_all'
    end
  end

  post 'group_categories/update_all_sub_groups', to: 'group_categories#update_all_sub_groups', as: :update_all_sub_groups
  patch '/groups/:id/auto_archive_switch', to: 'groups#auto_archive_switch', as: :auto_archive_switch
  patch '/groups/:group_id/initiatives/:id/archive', to: 'initiatives#archive', as: :archive_group_initiative
  patch '/groups/:group_id/initiatives/:id/restore', to: 'initiatives#restore', as: :restore_group_initiative
  patch 'initiatives/:initiative_id/resources/:id/restore', to: 'initiatives/resources#restore', as: :restore_initiative_resource
  delete 'initiatives/:initiative_id/resources/:id/', to: 'initiatives/resources#destroy', as: :remove_initiative_resource


  resources :groups do
    collection do
      post :sort
      get 'get_all_groups'
      get 'get_paginated_groups'
    end
    member do
      get 'slack_button_redirect'
      get 'slack_uninstall'
    end
    resources :budgets, only: [:index, :show, :new, :create, :destroy] do
      post 'approve'
      post 'decline'
      collection do
        get 'export_csv'
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
          post 'join_all_sub_groups'
          delete 'leave_all_sub_groups'
          get 'view_sub_groups'
          get 'export_group_members_list_csv'
          post 'export_sub_groups_members_list_csv'
          get 'view_list_of_sub_groups_for_export'
        end
        member do
          post 'accept_pending'
          delete 'remove_member'
          post 'join_sub_group'
          delete 'leave_sub_group'
        end
      end

      resources :group_messages, path: 'messages' do
        post 'create_comment'
        member { patch 'archive' }
        resources :group_message_comment
      end
      resources :leaders, only: [:index, :new, :create]
      resources :social_links do
        member { patch 'archive' }
      end
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

        resources :comments, only: [:create, :destroy], shallow: true

        collection do
          get 'calendar_view'
          get 'calendar_data'
        end

        member do
          get 'export_ics'
        end
      end

      resources :twitter_accounts do
        collection do
          get 'delete_all'
        end
      end

      resources :user_groups, only: :update

      resources :news_links, except: [:show] do
        member do
          get   'comments'
          get   'news_link_photos'
          post  'create_comment'
          patch 'archive'
        end
        resources :news_link_comment
      end
      resources :posts, only: [:index] do
        collection do
          get 'pending'
          post 'approve'
          patch 'pin'
          patch 'unpin'
        end
      end

      resources :folders do
        member do
          post 'authenticate'
        end
        scope module: :folder do
          resources :resources do
            member do
              patch 'archive'
              patch 'restore'
            end
          end
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

          collection do
            get 'joined_time_series'
          end
        end
        resources :resources do
          member { patch 'archive' }
        end
      end

      member do
        get 'todo'
        post 'finish_expenses'
        get 'export_attendees_csv'
      end

      collection do
        get 'export_csv'
        get 'archived'
      end
    end

    member do
      get 'settings'
      get 'layouts'
      get 'plan_overview'
      get 'export_csv'
      get 'import_csv'
      get 'sample_csv'
      post 'parse_csv'
      get 'metrics'
      get 'edit_fields'
      patch 'delete_attachment'
      patch 'update_questions'
      patch 'update_layouts'
      patch 'update_settings'
    end

    collection do
      get 'plan_overview'
      get 'close_budgets'
      get 'close_budgets_export_csv'
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

    resources :poll_responses, except: [:show, :edit], path: 'responses' do
      member do
        get 'thank_you'
      end
    end

    resources :poll_fields, only: [:show] do
      member do
        get 'answer_popularities'
      end
    end

    scope module: 'polls' do
      resources :graphs, only: [:new, :create, :edit, :update]
    end
  end

  resources :graphs do
    member do
      get 'data'
      get 'export_csv'
    end
  end

  resources :fields do
    member do
      get 'stats'
    end
  end

  resources :rewards, except: [:show] do
    collection do
      put 'enable'
    end
  end
  resources :badges, except: [:index, :show]

  resources :reward_actions, only: [] do
    collection do
      patch 'update'
    end
  end

  resources :segments do
    collection do
      get 'enterprise_segments'
      get 'get_all_segments'
      get 'get_paginated_segments'
    end
    resources :sub_segments

    member do
      get 'export_csv'
      get 'segment_status'
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
        resource :roi, controller: 'roi'
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
      get 'preferences/edit', to: 'users#edit'
      patch 'preferences/update', to: 'users#update'

      resources :social_links
      resources :news_links
      resources :messages
      resources :events do
        collection do
          get 'calendar'
          get 'onboarding_calendar_data'
        end
      end

      resources :downloads, only: [:index] do
        collection do
          get 'download'
        end
      end

      resources :resources
      resources :mentorship do
        collection do
          get 'mentors'
          get 'mentees'
          get 'requests'
          get 'sessions'
          get 'ratings'
        end
      end
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
        resources :user_rewards, only: [:create] do
          member do
            patch :approve_reward
            patch :forfeit_reward
            get :reward_to_be_forfeited
          end

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

      resources :users do
        member do
          get :edit_linkedin
          patch :linkedin, action: :update_linkedin
          delete :linkedin, action: :delete_linkedin
        end
      end
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

  resources :mentorings
  resources :mentoring_interests
  resources :mentoring_requests
  resources :mentoring_sessions do
    member do
      get 'start'
      get 'join'
      get 'export_ics'
    end
  end

  resources :mentoring_sessions do
    post 'create_comment'
    resources :mentoring_session_comments, only: [:edit, :update, :destroy]
    resources :mentorship_sessions, only: [:accept, :decline] do
      member do
        post 'accept'
        post 'decline'
      end
    end
  end

  resources :mentorship_ratings


  namespace :metrics do
    resources :overview, controller: :overview_graphs, only: [:index]
    resources :users, controller: :user_graphs, only: [:index] do
      collection do
        get 'users_per_group'
        get 'users_per_segment'
        get 'user_growth'
        get 'user_groups_intersection'
        get 'url_usage_data'
        get 'user_usage_data'
        get 'users_usage_graph'
        get 'users_usage_metric'
      end
    end

    resources :groups, controller: :group_graphs, only: [:index] do
      collection do
        get 'initiatives'
        get 'social_media'
        get 'resources'

        get 'group_population'
        get 'initiatives_per_group'
        get 'messages_per_group'
        get 'views_per_group'
        get 'views_per_folder'
        get 'views_per_resource'
        get 'views_per_news_link'
        get 'growth_of_groups'
        get 'growth_of_resources'
      end
    end

    resources :segments, controller: :segment_graphs, only: [:index] do
      collection do
        get 'segment_population'
      end
    end

    resources :mentorships, controller: :mentorship_graphs, only: [:index] do
      collection do
        get 'user_mentorship_interest_per_group'
        get 'mentoring_sessions_per_creator'
        get 'mentoring_interests'
        get 'mentors_per_group'
        get 'top_mentors'
        get 'users_mentorship_count'
        get 'user_mentors'
        get 'users_mentorship'
      end

      member do
        get 'user_mentorship'
      end
    end

    resources :campaigns, controller: :campaign_graphs, only: [:index] do
      collection do
        get 'contributions_per_erg'
        get 'total_votes_per_user'
      end
    end

    resources :metrics_dashboards do
      member do
        get 'shared_dashboard'
      end

      resources :graphs do
        member do
          get 'data'
          get 'export_csv'
        end
      end
    end
  end

  resource :generic_graphs do
    get 'group_population'
    get 'segment_population'
    get 'events_created'
    get 'messages_sent'
    get 'mentorship'
    get 'mentoring_sessions'
    get 'mentoring_interests'
    get 'top_groups_by_views'
    get 'top_folders_by_views'
    get 'top_resources_by_views'
    get 'top_news_by_views'
    get 'growth_of_employees'
    get 'growth_of_groups'
    get 'growth_of_resources'
  end

  namespace :website do
    resources :leads
  end

  resources :shared_news_feed_links

  resources :policy_group_templates
  resources :emails

  resources :custom_emails do
    member do
      post :deliver
    end
  end

  resources :custom_texts, only: [:edit, :update]

  resources :likes, only: [:create, :unlike]
  match '/likes/unlike' => 'likes#unlike', :via => :delete

  scope :views, controller: 'views' do
    post 'track'
  end

  match '*a', to: 'application#routing_error', via: [:get, :post]

  root to: 'application#root'
end

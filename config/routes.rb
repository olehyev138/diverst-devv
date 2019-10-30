Diverst::Application.routes.draw do
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_DASHBOARD_USERNAME'] && password == ENV['SIDEKIQ_DASHBOARD_PASSWORD']
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :api_keys
      resources :annual_budgets
      resources :answers
      resources :answer_comments
      resources :answer_expenses
      resources :answer_upvotes
      resources :badges
      resources :budgets
      resources :budget_items
      resources :campaigns
      resources :campaigns_groups
      resources :campaign_invitations
      resources :campaigns_managers
      resources :campaigns_segments
      resources :checklists
      resources :checklist_items
      resources :clockwork_database_events
      resources :custom_texts
      resources :devices
      resources :emails
      resources :email_variables
      resources :enterprises do
        member do
          post '/sso_login',    to: 'enterprises#sso_login'
          post '/sso_link',     to: 'enterprises#sso_link'
        end
      end
      resources :enterprise_email_variables
      resources :expenses
      resources :expense_categories
      resources :fields
      resources :field_data, path: 'field_data', only: [] do
        collection do
          post 'update_field_data'
        end
      end
      resources :folders do
        member do
          post '/password', to: 'folders#validate_password'
        end
      end
      resources :folder_shares
      resources :frequency_periods
      resources :graphs
      resources :groups
      resources :group_categories
      resources :group_category_types
      resources :group_leaders
      resources :group_messages
      resources :group_message_comments
      resources :group_messages_segments
      resources :group_updates
      resources :groups_metrics_dashboards
      resources :groups_polls
      resources :group_members, path: 'members' do
        collection do
          post 'add_members'
          post 'remove_members'
        end
      end
      resources :initiatives do
        member do
          post '/qrcode', to: 'initiatives#generate_qr_code'
        end
      end
      resources :initiative_comments
      resources :initiative_fields
      resources :initiative_expenses
      resources :initiative_groups
      resources :initiative_invitees
      resources :initiative_participating_groups
      resources :initiative_segments
      resources :initiative_updates
      resources :initiative_users
      resources :invitation_segments_groups
      resources :likes
      resources :mentorings do
        collection do
          post 'delete_mentorship'
        end
      end
      resources :mentoring_interests
      resources :mentoring_requests
      resources :mentoring_request_interests
      resources :mentoring_sessions
      resources :mentoring_session_comments
      resources :mentoring_session_topics
      resources :mentoring_types
      resources :mentorship_availabilities
      resources :mentorship_interests
      resources :mentorship_ratings
      resources :mentorship_sessions
      resources :mentorship_types
      resources :metrics_dashboards
      resources :metrics_dashboards_segments
      resources :mobile_fields
      resources :news_feeds
      resources :news_feed_links
      resources :news_feed_link_segments
      resources :news_links
      resources :news_link_comments
      resources :news_link_photos
      resources :news_link_segments
      resources :outcomes
      resources :pillars
      resources :policy_groups
      resources :policy_group_templates
      resources :polls
      resources :poll_responses
      resources :polls_segments
      resources :questions
      resources :resources
      resources :rewards
      resources :reward_actions
      resources :segment_group_scope_rules
      resources :segment_group_scope_rule_groups
      resources :segment_order_rules
      resources :segments do
        member do
          get 'status'
        end
      end
      resources :sessions, only: [:create, :destroy]
      resources :shared_metrics_dashboards
      resources :shared_news_feed_links
      resources :social_links
      resources :social_link_segments
      resources :sponsors
      resources :tags
      resources :topics
      resources :topic_feedbacks
      resources :twitter_accounts
      resources :user_rewards
      resources :user_reward_actions
      resources :user, only: [] do
        collection do
          get '/posts', to: 'user#get_posts'
          get '/joined_events', to: 'user#get_joined_events'
          get '/all_events', to: 'user#get_all_events'
        end
      end
      resources :users do
        collection do
          post '/email', to: 'users#find_user_enterprise_by_email'
        end
        member do
          get '/association', to: 'users#association'
        end
      end
      resources :user_groups
      resources :user_roles
      resources :users_segments
      resources :views
      resources :yammer_field_mappings

      namespace :metrics do
        resources :overview, controller: :overview_graphs, only: [] do
          get 'overview_metrics'
        end

        resources :users, controller: :user_graphs, only: [] do
          collection do
            get 'users_per_group'
            get 'users_per_segment'
            get 'user_growth'
            get 'user_groups_intersection'
            get 'url_usage_data'
            get 'user_usage_data'
          end
        end

        resources :groups, controller: :group_graphs, only: [] do
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

        resources :segments, controller: :segment_graphs, only: [] do
          collection do
            get 'segment_population'
          end
        end

        resources :mentorships, controller: :mentorship_graphs, only: [] do
          collection do
            get 'user_mentorship_interest_per_group'
            get 'mentoring_sessions_per_creator'
            get 'mentoring_interests'
            get 'mentors_per_group'
            get 'top_mentors'
          end
        end

        resources :campaigns, controller: :campaign_graphs, only: [] do
          collection do
            get 'contributions_per_erg'
            get 'total_votes_per_user'
          end
        end

        resources :metrics_dashboards do
          member do
            get 'shared_dashboard'
          end
        end

        resources :graphs do
          collection do
            get 'data'
            get 'export_csv'
          end
        end
      end
    end
  end

  match '*a', to: 'diverst#routing_error', via: [:get, :post]
end

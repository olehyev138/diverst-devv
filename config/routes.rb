Diverst::Application.routes.draw do
  require 'sidekiq/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_DASHBOARD_USERNAME'] && password == ENV['SIDEKIQ_DASHBOARD_PASSWORD']
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :api_keys
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
      resources :emails
      resources :email_variables
      resources :enterprises
      resources :enterprise_email_variables
      resources :expenses
      resources :expense_categories
      resources :fields
      resources :folders
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
      resources :initiatives
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
      resources :mentorings
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
      resources :news_feeds
      resources :resources
      resources :rewards
      resources :segments
      resources :sessions, only: [:create, :destroy]
      resources :users do
        collection do
          post '/email', to: 'users#find_user_by_email'
        end
      end
    end
  end

  match '*a', to: 'diverst#routing_error', via: [:get, :post]
end

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
      resources :initiatives
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

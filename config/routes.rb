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
      resources :budgets
      resources :budget_items
      resources :enterprises
      resources :groups
      resources :folders
      resources :news_feeds
      resources :group_leaders
      resources :resources
      resources :segments
      resources :users do
        collection do
          post '/email', to: 'users#find_user_by_email'
        end
      end
      resources :initiatives
      resources :campaigns
      resources :campaign_invitations
      resources :badges
      resources :rewards
      resources :sessions, only: [:create, :destroy]
    end
  end

  match '*a', to: 'diverst#routing_error', via: [:get, :post]
end

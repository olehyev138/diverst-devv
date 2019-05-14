module Metrics
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_graph
    before_action :parse_csv_date_range, only: [:group_population,
                                                :users_per_group,
                                                :initiatives_per_group,
                                                :messages_per_group,
                                                :growth_of_groups,
                                                :views_per_group,
                                                :views_per_folder,
                                                :views_per_resource,
                                                :views_per_news_link,
                                                :mentoring_sessions_per_creator
    ]
  end

  protected

  def set_graph
    @graph = Graph.new
    @graph.enterprise_id = current_user.enterprise_id
  end

  def parse_csv_date_range
    @from_date = metrics_params.dig(:date_range, :from_date)
    @to_date = metrics_params.dig(:date_range, :to_date)

    case @from_date
    when '1m'
      @from_date = (DateTime.now - 1.month).to_s
      @to_date = DateTime.now.to_s
    when '3m'
      @from_date = (DateTime.now - 3.months).to_s
      @to_date = DateTime.now.to_s
    when '6m'
      @from_date = (DateTime.now - 6.months).to_s
      @to_date = DateTime.now.to_s
    when 'ytd'
      @from_date = (DateTime.now.beginning_of_year).to_s
      @to_date = DateTime.now.to_s
    when '1y'
      @from_date = (DateTime.now - 1.year).to_s
      @to_date = DateTime.now.to_s
    when 'all'
      @from_date = nil
      @to_date = nil
    else
      @from_date = DateTime.parse(@from_date).to_s
      @to_date = DateTime.parse(@to_date).to_s
    end
  rescue
    @from_date = nil
    @to_date = nil
  end

  def metrics_params
    params.permit(
      date_range: [
        :from_date,
        :to_date
      ],
      scoped_by_models: []
    )
  end
end

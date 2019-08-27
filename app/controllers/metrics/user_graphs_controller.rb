class Metrics::UserGraphsController < ApplicationController
  include Metrics

  after_action :visit_page, only: [:index]

  layout 'metrics'

  def index
    authorize MetricsDashboard

    @user_metrics = {
      total_active_users: current_user.enterprise.users.active.count,
      user_growth: @graph.user_change_percentage,
      group_memberships: @graph.group_memberships
    }

    get_aggregate_usage_metrics

    respond_to do |format|
      format.html
    end
  end

  def users_usage_graph
    authorize MetricsDashboard, :index?

    metric = params['metric']
    if metric.blank?
      redirect_to :back
    end
    case metric
    when 'logins'
      data = User.aggregate_sign_ins
    else
      data = User.cached_count_list(*get_fields(metric), where: get_where(metric))
    end

    data.sort_by! { |datum| -datum[1] }

    data.map! do |datum|
      usr = User.find(datum[0])
      {
        x: usr.name,
        y: datum[1]
      }
    end

    respond_to do |format|
      format.json do
        render json: {
          title: "#{metric.capitalize} per User",
          type: 'bar',
          series: [{
                     key: "#{metric.capitalize} per User",
                     values: data
                   }]
        }
      end
    end
  end

  def users_usage_metric
    metric = params['metric']
    if metric.present?
      @graphs = [metric]
    else
      @graphs = %w(logins posts comments events)
    end
  end

  def get_fields(metric)
    case metric
    when 'posts'
      [:social_links, :own_messages, :own_news_links]
    when 'comments'
      [:answer_comments, :message_comments, :news_link_comments]
    when 'events'
      [:initiatives]
    else
      []
    end
  end

  def get_where(metric)
    case metric
    when 'events'
      ['initiatives.start < NOW() OR initiatives.id IS NULL']
    else
      [nil]
    end
  end

  def get_aggregate_usage_metrics
    logins_s, logins_mu, logins_m, logins_a, logins_sd = calculate_aggregate_data(User.aggregate_sign_ins)
    logins_n = 'Logins'

    posts_s, posts_mu, posts_m, posts_a, posts_sd = aggregate_data_from_field(User, *get_fields('posts'), where: get_where('posts'))
    posts_n = 'Posts Made'

    comments_s, comments_mu, comments_m, comments_a, comments_sd = aggregate_data_from_field(User, *get_fields('comments'), where: get_where('comments'))
    comments_n = 'Comments Made'

    events_s, events_mu, events_m, events_a, events_sd = aggregate_data_from_field(User, *get_fields('events'), where: get_where('events'))
    events_n = 'Events Attendance'

    @aggregate_metrics = {}
    @fields = %w(logins posts comments events)
    @fields.each do |type|
      @aggregate_metrics[type.to_sym] = {
        sum: binding.local_variable_get("#{type}_s"),
        max: binding.local_variable_get("#{type}_m"),
        max_user: binding.local_variable_get("#{type}_mu"),
        mean: binding.local_variable_get("#{type}_a"),
        sd: binding.local_variable_get("#{type}_sd"),
        name: binding.local_variable_get("#{type}_n"),
        label: type
      }
    end
  end

  def url_usage_data
    authorize User, :index?
    respond_to do |format|
      format.json { render json: AggregateUrlStatsDatatable.new(view_context) }
    end
  end

  def user_usage_data
    @users = current_user.enterprise.users
    respond_to do |format|
      format.json {
        render json: UserByUsageDatatable.new(view_context, @users)
      }
    end
  end

  def user_groups_intersection
    @users = current_user.enterprise.users
    @users = @graph.user_groups_intersection(metrics_params[:scoped_by_models]) if metrics_params[:scoped_by_models].present?

    respond_to do |format|
      format.json { render json: UserDatatable.new(view_context, @users, read_only: true) }
      format.csv {
        MetricsUserGroupsIntersectionDownloadJob.perform_later(current_user.id, @users.to_a)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def users_per_group
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.group_population(metrics_params[:date_range], nil)
      }
      format.csv {
        GenericGraphsGroupPopulationDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_group_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def users_per_segment
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.segment_population
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_segment_population)
        render json: { notice: 'Please check your Secure Downloads section in a couple of minutes' }
      }
    end
  end

  def user_growth
    authorize MetricsDashboard, :index?

    respond_to do |format|
      format.json {
        render json: @graph.user_growth(metrics_params[:date_range])
      }
    end
  end

  def visit_page
    super(page_name)
  end

  def page_name
    case action_name
    when 'index'
      'User Metrics'
    else
      "#{controller_path}##{action_name}"
    end
  rescue
    "#{controller_path}##{action_name}"
  end
end

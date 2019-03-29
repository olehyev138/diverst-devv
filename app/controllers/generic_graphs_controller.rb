class GenericGraphsController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper

  before_action   :authenticate_user!
  before_action   :authorize_dashboards
  before_action   :get_date_range, only: [:events_created,
                                          :messages_sent,
                                          :growth_of_groups,
                                          :top_groups_by_views
                                         ]

  def group_population
    respond_to do |format|
      format.json {
        graph = UserGroup.get_graph
        graph.set_enterprise_filter(field: 'group.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.title = "#{c_t(:erg).capitalize} Population"

        graph.query  = graph.query.terms_agg(field: 'group.name')
        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsGroupPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_group_population)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def segment_population
    respond_to do |format|
      format.json {
        graph = UsersSegment.get_graph
        graph.set_enterprise_filter(field: 'segment.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.title = "#{c_t(:segment).capitalize} Population"

        graph.query = graph.query.terms_agg(field: 'segment.name')
        graph.drilldown_graph(parent_field: 'segment.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_segment_population)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_events_created
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json{
        graph = Initiative.get_graph
        graph.set_enterprise_filter(field: 'pillar.outcome.group.enterprise_id', value: enterprise_id)

        graph.formatter.title = 'Events Created'
        graph.formatter.y_parser.parse_chain = graph.formatter.y_parser.date_range

        graph.query = graph.query.terms_agg(field: 'pillar.outcome.group.name') { |q|
          q.date_range_agg(field: 'created_at', range: date_range)
        }

        graph.drilldown_graph(parent_field: 'pillar.outcome.group.parent.name')
        render json: graph.build
      }
      format.csv {
        GenericGraphsEventsCreatedDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_events_created)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_messages_sent
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = GroupMessage.get_graph
        graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)

        graph.query = graph.query.terms_agg(field: 'group.name') { |q|
          q.date_range_agg(field: 'created_at', range: date_range)
        }

        graph.formatter.title = 'Messages Sent'
        graph.formatter.y_parser.parse_chain = graph.formatter.y_parser.date_range

        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsMessagesSentDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date
        )
        track_activity(current_user.enterprise, :export_generic_graphs_messages_sent)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_groups_by_views
    # set days to input if passed, otherwise default to 30
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.set_enterprise_filter(value: enterprise_id)

        graph.query = graph.query.terms_agg(field: 'group.name') { |q|
          q.date_range_agg(field: 'created_at', range: date_range)
        }

        graph.formatter.title = "# Views per #{c_t(:erg).capitalize}"
        graph.formatter.y_parser.parse_chain = graph.formatter.y_parser.date_range

        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsTopGroupsByViewsDownloadJob.perform_later(
          current_user.id,
          current_user.enterprise.id,
          c_t(:erg),
          false,
          @from_date,
          @to_date
          )
        track_activity(current_user.enterprise, :export_generic_graphs_top_groups_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_folders_by_views
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.set_enterprise_filter(value: current_user.enterprise_id)

        graph.query = graph.query.terms_agg(field: 'folder.id') { |q|
          q.date_range_agg(field: 'created_at', range: date_range) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter.title = '# Views per Folder'
        x_parser = graph.formatter.x_parser
        y_parser = graph.formatter.y_parser

        x_parser.parse_chain = x_parser.date_range { |p| p.top_hits }
        x_parser.extractor = -> (e, _) {
          return if e.blank? || e == 0
          group = e.dig(:folder, :group, :name) || 'Shared'
          group + ' ' + e[:folder][:name]
        }

        y_parser.key = :doc_count
        y_parser.parse_chain = y_parser.date_range

        graph.formatter.add_elements(graph.search)

        render json: graph.build

      }
      format.csv {
        GenericGraphsTopFoldersByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, false)
        track_activity(current_user.enterprise, :export_generic_graphs_top_folders_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_resources_by_views
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.set_enterprise_filter(value: current_user.enterprise_id)

        graph.query = graph.query.terms_agg(field: 'resource.id') { |q|
          q.date_range_agg(field: 'created_at', range: date_range) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter.title = '# Views per Resource'

        x_parser = graph.formatter.x_parser
        y_parser = graph.formatter.y_parser

        x_parser.parse_chain = x_parser.date_range { |p| p.top_hits }
        x_parser.extractor = -> (e, _) {
          return if e.blank? || e == 0
          group = e.dig(:resource, :group, :name) || 'Shared'
          group + ' ' + e[:resource][:title]
        }

        y_parser.key = :doc_count
        y_parser.parse_chain = y_parser.date_range

        graph.formatter.add_elements(graph.search)

        results = graph.build

        render json: results
      }
      format.csv {
        GenericGraphsTopResourcesByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, false)
        track_activity(current_user.enterprise, :export_generic_graphs_top_resources_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_news_by_views
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.set_enterprise_filter(value: enterprise_id)

        graph.query = graph.query.terms_agg(field: 'news_feed_link.news_link.id') { |q|
          q.date_range_agg(field: 'created_at', range: date_range) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter.title = '# Views per News Link'
        x_parser = graph.formatter.x_parser
        y_parser = graph.formatter.y_parser

        x_parser.parse_chain = x_parser.date_range { |p| p.top_hits }
        x_parser.extractor = -> (e, _) {
          return if e.blank? || e == 0
          group = e.dig(:news_feed_link, :group, :name) || 'Shared'
          group + ' ' + e[:news_feed_link][:news_link][:title]
        }

        y_parser.key = :doc_count
        y_parser.parse_chain = y_parser.date_range

        elements = graph.formatter.list_parser.parse_list(graph.search)
        graph.formatter.add_elements(elements)

        render json: graph.build
      }
      format.csv {
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, false)
        track_activity(current_user.enterprise, :export_generic_graphs_top_news_by_views)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_employees
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = User.get_graph
        graph.set_enterprise_filter(value: enterprise_id)

        # build query
        graph.query = graph.query.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc') { |q|
          q.date_range_agg(field: 'created_at', range: date_range)
        }

        # setup formatter & parsers
        graph.formatter.type = 'line'
        graph.formatter.title = 'Growth of employees'

        y_parser = graph.formatter.y_parser
        y_parser.parse_chain = y_parser.date_range
        y_parser.extractor = -> (_, args) {
          args[:total]
        }

        # run query
        elements = graph.formatter.list_parser.parse_list(graph.search)

        # build graph
        total = 0
        graph.formatter.add_series
        gen_parser = graph.formatter.general_parser
        gen_parser.parse_chain = gen_parser.date_range
        gen_parser.key = :doc_count

        elements.each { |e|
          total += gen_parser.parse(e)
          graph.formatter.add_element(e, total: total)
        }

        render json: graph.build
      }
    end
  end

  def growth_of_groups
    respond_to do |format|
      format.json {
        graph = UserGroup.get_graph
        graph.set_enterprise_filter(field: 'group.enterprise_id', value: enterprise_id)

        graph.formatter.type = 'line'
        graph.formatter.title = "Growth of #{c_t(:erg).pluralize.capitalize}"
        graph.formatter.y_parser.extractor = -> (_, args) {
          args[:total]
        }

        gen_parser = graph.formatter.general_parser
        gen_parser.key = :doc_count

        current_user.enterprise.groups.each do |group|
          graph.query = graph.query
            .filter_agg(field: 'group_id', value: group.id) { |q|
            q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc')
          }
          elements = graph.formatter.list_parser.parse_list(graph.search)

          # each group is a new series/line on our line graph
          total = 0
          graph.formatter.add_series(series_name: group.name)

          elements.each { |e|
            total += gen_parser.parse(e)
            graph.formatter.add_element(e, total: total)
          }
        end
        
        render json: graph.build
      }
      format.csv {
        GenericGraphsGroupGrowthDownloadJob
          .perform_later(current_user.id, current_user.enterprise.id,
          @from_date, @to_date)
        track_activity(current_user.enterprise, :export_generic_graphs_group_growth)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_resources
    respond_to do |format|
      format.json {
        graph = Resource.get_graph
        graph.set_enterprise_filter(field: 'folder.group.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.type = 'line'
        graph.formatter.title = 'Growth of Resources'

        gen_parser = graph.formatter.general_parser
        gen_parser.key = :doc_count
        graph.formatter.y_parser.extractor = -> (_, args) {
          args[:total]
        }

        current_user.enterprise.groups.each do |group|
          graph.query = graph.query
            .filter_agg(field: 'folder.group_id', value: group.id) { |q|
            q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc')
          }

          elements = graph.formatter.list_parser.parse_list(graph.search)

          total = 0
          graph.formatter.add_series(series_name: group.name)

          elements.each { |e|
            total += gen_parser.parse(e)
            graph.formatter.add_element(e, total: total)
          }
        end

        render json: graph.build
      }
    end
  end

  def mentorship
    respond_to do |format|
      format.json {
        graph = UserGroup.get_graph
        graph.set_enterprise_filter(field: 'group.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.title = 'Users interested in Mentorship'

        graph.query = graph.query.bool_filter_agg { |qq| qq.terms_agg(field: 'group.name') }
        graph.query.add_filter_clause(field: 'user.active', value: true, bool_op: :must)
        graph.query.add_filter_clause(field: 'user.mentor', value: true, bool_op: :should)
        graph.query.add_filter_clause(field: 'user.mentee', value: true, bool_op: :should)

        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsMentorshipDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_mentorship)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_sessions
    date_range = parse_date_range(params[:input])

    respond_to do |format|
      format.json {
        graph = MentoringSession.get_graph
        graph.set_enterprise_filter(field: 'creator.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.title = 'Mentoring Sessions'

        graph.query = graph.query.bool_filter_agg { |qq| qq.terms_agg(field: 'creator.last_name') { |qqq|
            qqq.date_range_agg(field: 'created_at', range: date_range)
          }
        }

        graph.query.add_filter_clause(field: 'creator.active', value: true, bool_op: :must)
        graph.formatter.y_parser.parse_chain = graph.formatter.y_parser.date_range

        graph.formatter.add_elements(graph.search)

        render json: graph.build
      }
      format.csv {
        GenericGraphsMentoringSessionsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_sessions)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_interests
    respond_to do |format|
      format.json {
        graph = MentorshipInterest.get_graph
        graph.set_enterprise_filter(field: 'user.enterprise_id', value: current_user.enterprise_id)

        graph.formatter.title = 'Mentoring Interests'

        graph.query  = graph.query.terms_agg(field: 'mentoring_interest.name')
        graph.formatter.add_elements(graph.search)

        render json: graph.build
      }
      format.csv {
        GenericGraphsMentoringInterestsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        track_activity(current_user.enterprise, :export_generic_graphs_mentoring_interests)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def events_created
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_events_created
    else
      non_demo_events_created
    end
  end

  def messages_sent
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_messages_sent
    else
      non_demo_messages_sent
    end
  end

  def top_groups_by_views
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_top_groups_by_views
    else
      non_demo_top_groups_by_views
    end
  end

  def top_folders_by_views
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_top_folders_by_views
    else
      non_demo_top_folders_by_views
    end
  end

  def top_resources_by_views
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_top_resources_by_views
    else
      non_demo_top_resources_by_views
    end
  end

  def top_news_by_views
    if ENV["DOMAIN"] === "dm.diverst.com"
      demo_top_news_by_views
    else
      non_demo_top_news_by_views
    end
  end

  # FOR DEMO PURPOSES

  def demo_events_created
    respond_to do |format|
      format.json{
        categories = current_user.enterprise.groups.map(&:name)

        values = [2,3,4,1,6,8,5,8,3,4,1,5]
        i = 0
        data = current_user.enterprise.groups.map { |g| g.initiatives.where('initiatives.created_at > ?', 1.month.ago).count + values[i+=1] }

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Events created',
              data: data
            }],
            categories: categories,
            xAxisTitle: 'ERG',
            yAxisTitle: 'Nb of events'
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_messages_sent
    respond_to do |format|
      format.json {
        categories = current_user.enterprise.groups.map(&:name)

        values = [3,2,5,1,7,10,9,5,11,4,1,5]
        i = 0
        data = current_user.enterprise.groups.map { |g| g.messages.where('created_at > ?', 1.month.ago).count + values[i+=1] }

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Messages sent',
              data: data
            }],
            categories: categories,
            xAxisTitle: 'ERG',
            yAxisTitle: 'Nb of messages'
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_top_groups_by_views
    respond_to do |format|
      format.json {
        values = [8,1,2,1,7,5,9,5,11,7,6,2]
        i = 0
        data = current_user.enterprise.groups.all_parents.map do |g|
          {
            y: values[i+=1],
            name: g.name
          }
        end

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: "# of views per #{c_t(:erg)}",
              data: data
            }],
            #categories: categories,
            xAxisTitle: "#{c_t(:erg)}",
            yAxisTitle: "# of views per #{c_t(:erg)}"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsTopGroupsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_top_folders_by_views
    respond_to do |format|
      format.json {
        group_ids = current_user.enterprise.groups.ids
        folders = Folder.where(:group_id => group_ids).only_parents

        values = [5,2,5,1,7,1,4,5,11,4,3,8]
        i = 0

        data = folders.map do |f|
          {
            y: values[i+=1],
            name: f.name,
            drilldown: f.name
          }
        end

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: "# of views per folder",
              data: data
            }],
            #categories: categories,
            xAxisTitle: "Folder",
            yAxisTitle: "# of views per folder"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsTopFoldersByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_top_resources_by_views
    respond_to do |format|
      format.json {
        group_ids = current_user.enterprise.groups.ids
        folder_ids = Folder.where(:group_id => group_ids).ids
        resources = Resource.where(:folder_id => folder_ids)

        values = [4,2,5,4,7,4,9,5,11,4,1,5]
        i = 0

        data = resources.map do |resource|
          {
            y: values[i+=1],
            name: resource.title
          }
        end

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: "# of views per resource",
              data: data
            }],
            #categories: categories,
            xAxisTitle: "Resource",
            yAxisTitle: "# of views per resource"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsTopResourcesByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_top_news_by_views
    respond_to do |format|
      format.json {
        news_feed_link_ids = NewsFeedLink.where(:news_feed_id => NewsFeed.where(:group_id => current_user.enterprise.groups.ids).ids).ids
        news_links = NewsLink.select("news_links.title, SUM(views.view_count) view_count").joins(:news_feed_link, :news_feed_link => :views).where(:news_feed_links => {:id => news_feed_link_ids}).order("view_count DESC")

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: "# of views per news link",
              data: data
            }],
            #categories: categories,
            xAxisTitle: "Resource",
            yAxisTitle: "# of views per news link"
          },
          hasAggregation: false
        }

      }
      format.csv {
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def demo_top_news_by_views
    respond_to do |format|
      format.json {
        news_feed_link_ids = NewsFeedLink.where(:news_feed_id => NewsFeed.where(:group_id => current_user.enterprise.groups.ids).ids).ids
        news_links = NewsLink.select("news_links.title, COUNT(views.id) view_count").joins(:news_feed_link, :news_feed_link => :views).where(:news_feed_links => {:id => news_feed_link_ids}).order("view_count DESC")

        values = [9,2,5,1,11,10,9,5,11,4,1,8]
        i = 0

        data = news_links.map do |news_link|
          {
            y: values[i+=1],
            name: news_link.title
          }
        end

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: "# of views per news link",
              data: data
            }],
            #categories: categories,
            xAxisTitle: "Resource",
            yAxisTitle: "# of views per news link"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, true)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def authorize_dashboards
    authorize MetricsDashboard, :index?
  end

  private

  def get_date_range
    begin
      @from_date = params.dig(:input, :from_date)
      @to_date = params.dig(:input, :to_date)
    rescue
      @from_date = nil
      @to_date = nil
    end
  end

  def parse_date_range(date_range)
    # Parse a date range from a frontend range_controller for a es date range aggregation
    # Date range is {} or looks like { from: <>, to: <> }, with to being optional

    default_from_date = 'now-200y/y'
    default_to_date = DateTime.tomorrow.strftime('%F')

    return { from: default_from_date, to: default_to_date } if date_range.blank?

    from_date = date_range[:from_date].presence || default_from_date
    to_date = DateTime.parse((date_range[:to_date].presence || default_to_date)).strftime('%F')

    from_date = case from_date
                when '1m'     then 'now-1M/M'
                when '3m'     then 'now-3M/M'
                when '6m'     then 'now-6M/M'
                when 'ytd'    then Time.now.beginning_of_year.strftime('%F')
                when '1y'     then 'now-1y/y'
                when 'all'    then 'now-200y/y'
                else
                  DateTime.parse(from_date).strftime('%F')
                end

    { from: from_date, to: to_date }
  end

  def enterprise_id
    current_user.enterprise_id
  end

  def graph_params
    params.permit(
      :input
    )
  end
end

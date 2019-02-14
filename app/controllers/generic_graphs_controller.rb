class GenericGraphsController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper

  before_action   :authenticate_user!
  before_action   :authorize_dashboards

  def group_population
    respond_to do |format|
      format.json {
        graph = UserGroup.get_graph
        graph.enterprise_filter = { 'group.enterprise_id' => current_user.enterprise_id }
        graph.query  = graph.query.terms_agg(field: 'group.name')
        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
    end
  end

  def segment_population
    respond_to do |format|
      format.json {
        graph = UsersSegment.get_graph
        graph.enterprise_filter = { 'segment.enterprise_id' => current_user.enterprise_id }
        graph.query = graph.query.terms_agg(field: 'segment.name')
        graph.drilldown_graph(parent_field: 'segment.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_events_created
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json{
        graph = Initiative.get_graph
        graph.enterprise_filter = { 'pillar.outcome.group.enterprise_id' => current_user.enterprise_id }

        graph.query = graph.query.terms_agg(field: 'pillar.outcome.group.name') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"})
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          { label: e[:key], value: e.agg.buckets[0][:doc_count] }
        }

        graph.drilldown_graph(parent_field: 'pillar.outcome.group.parent.name')
        render json: graph.build
      }
      format.csv {
        GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_messages_sent
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json {
        graph = GroupMessage.get_graph
        graph.enterprise_filter = { 'group.enterprise_id' => current_user.enterprise_id }

        graph.query = graph.query.terms_agg(field: 'group.name') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"})
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          { label: e[:key], value: e.agg.buckets[0][:doc_count] }
        }

        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsMessagesSentDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_groups_by_views
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.enterprise_filter = { 'enterprise_id' => current_user.enterprise_id }

        graph.query = graph.query.terms_agg(field: 'group.name') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"})
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          { label: e[:key], value: e.agg.buckets[0][:doc_count] }
        }

        graph.drilldown_graph(parent_field: 'group.parent.name')

        render json: graph.build
      }
      format.csv {
        GenericGraphsTopGroupsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_folders_by_views
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.enterprise_filter = { 'enterprise_id' => current_user.enterprise_id }

        graph.query = graph.query.terms_agg(field: 'folder.id') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"}) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          e_folder =  e.agg.buckets[0].agg.hits.hits[0][:_source][:folder]
          group_name = e_folder[:group].present? ? e_folder[:group][:name] : 'Shared'

          { label: group_name + ': ' + e_folder[:name],
            value: e.agg.buckets[0][:doc_count]
          }
        }
        graph.formatter.key_formatter = -> (e) {
          e.agg.buckets[0].agg.hits.hits[0][:_source][:folder][:id]
        }

        graph.formatter.add_elements(graph.search)

        results = graph.build


        render json: results
      }
      format.csv {
        GenericGraphsTopFoldersByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_resources_by_views
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.enterprise_filter = { 'enterprise_id' => current_user.enterprise_id }

#        graph.query = graph.query.terms_agg(field: 'folder.id') { |q|
#          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"}) { |qq| qq.top_hits_agg }
#        }

        graph.query = graph.query.terms_agg(field: 'resource.id') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"}) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          e_resource =  e.agg.buckets[0].agg.hits.hits[0][:_source][:resource]
          group_name = e_resource[:group].present? ? e_resource[:group][:name] : 'Shared'

          { label: group_name + ': ' + e_resource[:title],
            value: e.agg.buckets[0][:doc_count]
          }
        }
        graph.formatter.key_formatter = -> (e) {
          e.agg.buckets[0].agg.hits.hits[0][:_source][:resource][:id]
        }

        graph.formatter.add_elements(graph.search)

        results = graph.build

        render json: results
      }
      format.csv {
        GenericGraphsTopResourcesByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def non_demo_top_news_by_views
    # set days to input if passed, otherwise default to 30
    days = ((params[:input] =~ /\A-?\d+\Z/) ? params[:input] : '30')

    respond_to do |format|
      format.json {
        graph = View.get_graph
        graph.enterprise_filter = { 'enterprise_id' => current_user.enterprise_id }

        graph.query = graph.query.terms_agg(field: 'news_feed_link.news_link.id') { |q|
          q.date_range_agg(field: 'created_at', range: { from: "now-#{days}d/d"}) { |qq|
            qq.top_hits_agg
          }
        }

        graph.formatter = graph.get_custom_formatter
        graph.formatter.element_formatter = -> (e) {
          # Look at the View mapping to get a handle on this.
          # Essentially we need to aggregate by id, but display '<group>: <title>', this is what causes this mess
          e_news_feed_link =  e.agg.buckets[0].agg.hits.hits[0][:_source][:news_feed_link]
          group_name = e_news_feed_link[:group].present? ? e_news_feed_link[:group][:name] : 'Shared'

          { label: group_name + ': ' + e_news_feed_link[:news_link][:title],
            value: e.agg.buckets[0][:doc_count]
          }
        }
        graph.formatter.key_formatter = -> (e) {
          e.agg.buckets[0].agg.hits.hits[0][:_source][:news_feed_link][:news_link][:id]
        }

        graph.formatter.add_elements(graph.search)

        render json: graph.build
      }
      format.csv {
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_groups
    respond_to do |format|
      # TODO: confirm were not including enterprise resources/folders

      format.json {
        graph = UserGroup.get_graph
        graph.enterprise_filter = { 'group.enterprise_id' => current_user.enterprise_id }
        graph.formatter = graph.get_custom_formatter
        graph.formatter.title = 'Growth of Groups'
        graph.formatter.type = 'line'
        graph.formatter.element_formatter = -> (e, *args) {
          { label: Date.parse(e[:key_as_string]).strftime('%Y-%m-%d'),
            value: args[0] , # args[0] -> total so far
            key: 'series0' }
        }

        current_user.enterprise.groups.each do |group|
          graph.query = graph.query
            .filter_agg(field: 'group_id', value: group.id) { |q|
              q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc')
          }

          total = 0
          elements = graph.search
          elements.each { |element|
            # keep a running total
            graph.formatter.add_element(element, (total += element[:doc_count]))
          }

          # each group is a new series/line on our line graph
          graph.formatter.add_series
        end

        render json: graph.build
      }
      format.csv {
        GenericGraphsGroupGrowthDownloadJob
          .perform_later(current_user.id, current_user.enterprise.id,
          params[:from_date], params[:to_date])

        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def growth_of_resources
    # TODO: confirm were not including enterprise resources/folders

    respond_to do |format|
      format.json {
        graph = Resource.get_graph
        graph.enterprise_filter = { 'folder.group.enterprise_id' => current_user.enterprise_id }
        graph.formatter = graph.get_custom_formatter
        graph.formatter.title = 'Growth of Resources'
        graph.formatter.type = 'DEBUGNULLEDOUT'
        graph.formatter.element_formatter = -> (e, *args) {
          { label: e[:key_as_string], value: args[0] } # args[0] -> total so far
        }

        current_user.enterprise.groups.each do |group|
          graph.query = graph.query
            .filter_agg(field: 'folder.group_id', value: group.id) { |q|
              q.terms_agg(field: 'created_at', order_field: '_term', order_dir: 'asc')
          }

          total = 0
          elements = graph.search
          elements.each { |element|
            graph.formatter.add_element(element, (total += element[:doc_count]))
          }

          graph.formatter.add_series
        end

        render json: graph.build
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

  def mentorship
    respond_to do |format|
      format.json {
        data = current_user.enterprise.groups.all_parents.map { |g|
          {
            y: g.members.active.mentors_and_mentees.count,
            name: g.name,
            drilldown: g.name
          }
        }
        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
          {
            name: g.name,
            id: g.name,
            data: g.children.map {|child| [child.name, child.members.active.mentors_and_mentees.active.count]}
          }
        }

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Number of mentors/mentees',
              data: data
            }],
            drilldowns: drilldowns,
            #categories: categories, <- for some reason this is causing drilldowns to not appear
            xAxisTitle: "#{c_t(:erg)}"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsMentorshipDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_sessions
    respond_to do |format|
      format.json {
        data = current_user.enterprise.groups.all_parents.map { |g|
          {
            y: g.members.active.mentors_and_mentees.joins(:mentoring_sessions).where("mentoring_sessions.created_at > ? ", 1.month.ago).count,
            name: g.name,
            drilldown: g.name
          }
        }

        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
          {
            name: g.name,
            id: g.name,
            data: g.children.map {|child| [child.name, child.members.active.mentors_and_mentees.joins(:mentoring_sessions).where("mentoring_sessions.created_at > ?", 1.month.ago).count]}
          }
        }

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Number of mentoring sessions',
              data: data
            }],
            drilldowns: drilldowns,
            #categories: categories, <- for some reason this is causing drilldowns to not appear
            xAxisTitle: "#{c_t(:erg)}"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsMentoringSessionsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
    end
  end

  def mentoring_interests
    respond_to do |format|
      format.json {
        data = current_user.enterprise.mentoring_interests.includes(:users).map { |mi|
          {
            y: mi.users.count,
            name: mi.name,
            drilldown: nil
          }
        }

        render json: {
          type: 'bar',
          highcharts: {
            series: [{
              title: 'Number of mentoring sessions',
              data: data
            }],
            drilldowns: [],
            #categories: categories, <- for some reason this is causing drilldowns to not appear
            xAxisTitle: "#{c_t(:erg)}"
          },
          hasAggregation: false
        }
      }
      format.csv {
        GenericGraphsMentoringInterestsDownloadJob.perform_later(current_user.id, current_user.enterprise.id)
        flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
        redirect_to :back
      }
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

  # FOR NON DEMO PURPOSES

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
        GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: true)
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
        GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: true)
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
        GenericGraphsTopGroupsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: true)
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
        GenericGraphsTopFoldersByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: true)
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
        GenericGraphsTopResourcesByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: true)
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
        GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: true)
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
              GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: true)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

  def authorize_dashboards
    authorize MetricsDashboard, :index?
  end

  private

  def graph_params
    params.permit(
      :input
    )
  end
end

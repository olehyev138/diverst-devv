class GenericGraphsController < ApplicationController
    include ActionView::Helpers::JavaScriptHelper

    before_action :authenticate_user!

    def group_population
        data = current_user.enterprise.groups.all_parents.map { |g|
            {
                y: g.members.active.count,
                name: g.name,
                drilldown: g.name
            }
        }
        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.members.active.count]}
            }
        }
        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Number of users',
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of users #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_group_population.csv"
            }
        end
    end

    def segment_population
        segments = current_user.enterprise.segments.includes(:parent).where(:segmentations => {:parent_id => nil})

        data = segments.map { |s|
            {
                y: s.members.active.count,
                name: s.name,
                drilldown: s.name
            }
        }
        drilldowns = segments.includes(:sub_segments).map { |s|
            {
                name: s.name,
                id: s.name,
                data: s.sub_segments.map {|sub| [sub.name, sub.members.active.count]}
            }
        }
        categories = segments.map{ |s| s.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   name: 'Number of users',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               #categories: categories, <- for some reason this is causing drilldowns to not appear
                               xAxisTitle: c_t(:segment)
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of users by #{c_t(:badge)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_segment_population.csv"
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
        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of mentors/mentees #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_group_mentorship.csv"
            }
        end
    end

    def mentoring_sessions

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

        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of mentoring sessions #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_group_mentoring_sessions.csv"
            }
        end
    end

    def mentoring_interests
        data = current_user.enterprise.mentoring_interests.includes(:users).map { |mi|
            {
                y: mi.users.count,
                name: mi.name,
                drilldown: nil
            }
        }
        categories = current_user.enterprise.mentoring_interests.map{ |mi| mi.name }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Mentoring Interests}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "mentoring_interests.csv"
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

    def non_demo_events_created
        data = current_user.enterprise.groups.all_parents.map do |g|
            {
                y: g.initiatives.joins(:owner)
                    .where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count,
                name: g.name,
                drilldown: g.name
            }
        end

        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.initiatives.joins(:owner)
                    .where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count]}
            }
        }

        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json{
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Events created',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               #categories: categories,
                               xAxisTitle: "#{c_t(:erg)}",
                               yAxisTitle: 'Nb of events'
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of events created #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_events_created.csv"
            }
        end
    end

    def non_demo_messages_sent
        data = current_user.enterprise.groups.all_parents.map do |g|
            {
                y: g.messages.joins(:owner)
                    .where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count,
                name: g.name,
                drilldown: g.name
            }
        end

        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.messages.joins(:owner)
                    .where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count]}
            }
        }

        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: 'Messages sent',
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               #categories: categories,
                               xAxisTitle: 'ERG',
                               yAxisTitle: 'Nb of messages'
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of messages sent #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "graph_messages_sent.csv"
            }
        end
    end

    def non_demo_top_groups_by_views
        data = current_user.enterprise.groups.all_parents.map do |g|
            {
                y: g.total_views,
                name: g.name,
                drilldown: g.name
            }
        end

        drilldowns = current_user.enterprise.groups.includes(:children).all_parents.map { |g|
            {
                name: g.name,
                id: g.name,
                data: g.children.map {|child| [child.name, child.total_views]}
            }
        }

        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: "# of views per #{c_t(:erg)}",
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               #categories: categories,
                               xAxisTitle: "#{c_t(:erg)}",
                               yAxisTitle: "# of views per #{c_t(:erg)}"
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_#{c_t(:erg)}.csv"
            }
        end
    end

    def non_demo_top_folders_by_views
        folders = Folder.all
        data = folders.map do |f|
          {
            y: f.total_views,
            name: !f.group.nil? ? f.group.name + ': ' + f.name : 'Shared folder: ' + f.name,
            drilldown: f.name
          }
        end

        drilldowns = folders.map { |f|
            {
                name: f.name,
                id: f.name,
                data: f.children.map {|child| [child.name, child.total_views]}
            }
        }

        categories = folders.map{ |f| f.name }

        respond_to do |format|
            format.json {
                render json: {
                           type: 'bar',
                           highcharts: {
                               series: [{
                                   title: "# of views per folder",
                                   data: data
                               }],
                               drilldowns: drilldowns,
                               #categories: categories,
                               xAxisTitle: "Folder",
                               yAxisTitle: "# of views per folder"
                           },
                           hasAggregation: false
                       }
            }
            format.csv {
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per folder", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_folder.csv"
            }
        end
    end

    def non_demo_top_resources_by_views
        group_ids = current_user.enterprise.groups.ids
        folder_ids = Folder.where(:group_id => group_ids).ids
        resources = Resource.where(:folder_id => folder_ids)
        data = resources.map do |resource|
            {
                y: resource.total_views,
                name: resource.title
            }
        end

        categories = resources.map{ |r| r.title }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per resource", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_resource.csv"
            }
        end
    end

    def non_demo_top_news_by_views
        news_feed_link_ids = NewsFeedLink.where(:news_feed_id => NewsFeed.where(:group_id => current_user.enterprise.groups.ids).ids).ids
        news_links = NewsLink.select("news_links.title, SUM(views.view_count) view_count").joins(:news_feed_link, :news_feed_link => :views).where(:news_feed_links => {:id => news_feed_link_ids}).order("view_count DESC")

        data = news_links.map do |news_link|
            {
                y: news_link.view_count,
                name: news_link.title
            }
        end

        categories = news_links.map{ |r| r.title }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per news link", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_news_link.csv"
            }
        end
    end

    # FOR DEMO PURPOSES

    def demo_events_created
        categories = current_user.enterprise.groups.map(&:name)

        values = [2,3,4,1,6,8,5,8,3,4,1,5]
        i = 0
        data = current_user.enterprise.groups.map { |g| g.initiatives.where('initiatives.created_at > ?', 1.month.ago).count + values[i+=1] }

        respond_to do |format|
          format.json{
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
            strategy = Reports::GraphStatsGeneric.new(title: 'Number of events created ERG', categories: categories, data: data)
            report = Reports::Generator.new(strategy)
            send_data report.to_csv, filename: "graph_events_created.csv"
          }
        end
    end

    def demo_messages_sent
        categories = current_user.enterprise.groups.map(&:name)

        values = [3,2,5,1,7,10,9,5,11,4,1,5]
        i = 0
        data = current_user.enterprise.groups.map { |g| g.messages.where('created_at > ?', 1.month.ago).count + values[i+=1] }

        respond_to do |format|
          format.json {
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
            strategy = Reports::GraphStatsGeneric.new(title: 'Number of messages sent ERG', categories: categories, data: data)
            report = Reports::Generator.new(strategy)
            send_data report.to_csv, filename: "graph_messages_sent.csv"
          }
        end
    end

    def demo_top_groups_by_views
        values = [8,1,2,1,7,5,9,5,11,7,6,2]
        i = 0
        data = current_user.enterprise.groups.all_parents.map do |g|
            {
                y: values[i+=1],
                name: g.name
            }
        end

        categories = current_user.enterprise.groups.all_parents.map{ |g| g.name }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per #{c_t(:erg)}", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_#{c_t(:erg)}.csv"
            }
        end
    end

    def demo_top_folders_by_views
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

        categories = folders.map{ |f| f.name }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per folder", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_folder.csv"
            }
        end
    end

    def demo_top_resources_by_views
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

        categories = resources.map{ |r| r.title }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per resource", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_resource.csv"
            }
        end
    end

    def demo_top_news_by_views
        news_feed_link_ids = NewsFeedLink.where(:news_feed_id => NewsFeed.where(:group_id => current_user.enterprise.groups.ids).ids).ids
        news_links = NewsLink.select("news_links.title, SUM(views.view_count) view_count").joins(:news_feed_link, :news_feed_link => :views).where(:news_feed_links => {:id => news_feed_link_ids}).order("view_count DESC")

        values = [9,2,5,1,11,10,9,5,11,4,1,8]
        i = 0

        data = news_links.map do |news_link|
            {
                y: values[i+=1],
                name: news_link.title
            }
        end

        categories = news_links.map{ |r| r.title }

        respond_to do |format|
            format.json {
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
                strategy = Reports::GraphStatsGeneric.new(title: "Number of view per news link", categories: categories, data: data)
                report = Reports::Generator.new(strategy)
                send_data report.to_csv, filename: "views_per_news_link.csv"
            }
        end
    end
end

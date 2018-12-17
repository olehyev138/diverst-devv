class GenericGraphsController < ApplicationController
    include ActionView::Helpers::JavaScriptHelper

    before_action   :authenticate_user!
    before_action   :authorize_dashboards

    def group_population
        respond_to do |format|
            format.json {
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
              GenericGraphsGroupPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def segment_population
        respond_to do |format|
            format.json {
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
              GenericGraphsSegmentPopulationDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg))
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

    def non_demo_events_created
        respond_to do |format|
            format.json{
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
              GenericGraphsEventsCreatedDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def non_demo_messages_sent
        respond_to do |format|
            format.json {
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
              GenericGraphsMessagesSentDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def non_demo_top_groups_by_views
        respond_to do |format|
            format.json {
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
              GenericGraphsTopGroupsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, c_t(:erg), demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def non_demo_top_folders_by_views
        respond_to do |format|
            format.json {
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
              GenericGraphsTopFoldersByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def non_demo_top_resources_by_views
        respond_to do |format|
            format.json {
              group_ids = current_user.enterprise.groups.ids
              folder_ids = Folder.where(:group_id => group_ids).ids
              resources = Resource.where(:folder_id => folder_ids)
              data = resources.map do |resource|
                  {
                      y: resource.total_views,
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
              GenericGraphsTopResourcesByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def non_demo_top_news_by_views
        respond_to do |format|
            format.json {
              news_feed_link_ids = NewsFeedLink.where(:news_feed_id => NewsFeed.where(:group_id => current_user.enterprise.groups.ids).ids).ids
              views = View.joins(:news_feed_link => :news_link).where(:news_feed_link_id => news_feed_link_ids).group("news_links.title").order("sum_view_count DESC").limit(20).sum(:view_count).to_a

              data = views.map do |view|
                  {
                      y: view.second,
                      name: view.first
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
              GenericGraphsTopNewsByViewsDownloadJob.perform_later(current_user.id, current_user.enterprise.id, demo: false)
              flash[:notice] = "Please check your Secure Downloads section in a couple of minutes"
              redirect_to :back
            }
        end
    end

    def growth_of_groups
      respond_to do |format|
        format.json {
          series = []

          current_user.enterprise.groups.each do |group|
            total = 0

            # query es, filter by current group id, order by created_at and aggregate on created_at
            buckets = UserGroup.__elasticsearch__.search({
              size: 0,
              aggs: {
                group_growth_agg: {
                  filter: { term: { group_id: group.id } },
                  aggs: {
                    group_growth_agg: {
                      terms: {
                        size: 1000,
                        field: :created_at,
                        order: { _term: :asc }
                      }
                    }
                  }
                }
              }
            }).aggregations.group_growth_agg.group_growth_agg.buckets

            # format es query response
            # get running total by adding each buckets doc count to a total
            series << {
              name: group.name,
              data: buckets.map { |bucket| [ bucket[:key], (total += bucket[:doc_count]) ] }
            }
          end

          render json: {
            type: 'time_based',
            highcharts: {
              series: series
            }
          }
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
      respond_to do |format|
        format.json {
          series = []
          current_user.enterprise.groups.each do |group|
            total = 0

            # query es, filter by current group id, order by created_at and aggregate on created_at
            buckets = Resource.__elasticsearch__.search({
              size: 0,
              aggs: {
                group_growth_agg: {
                  filter: {
                    term: { 'folder.group_id': group.id }
                  },
                  aggs: {
                    group_growth_agg: {
                      terms: {
                        size: 1000,
                        field: :created_at,
                        order: { _term: :asc }
                      }
                    }
                  }
                }
              }
            }).aggregations.group_growth_agg.group_growth_agg.buckets

            # format es query response
            # get running total by adding each buckets doc count to a total
            series << {
              name: group.name,
              data: buckets.map { |bucket| [ bucket[:key], (total += bucket[:doc_count]) ] }
            }
          end

          render json: {
            type: 'time_based',
            highcharts: {
              series: series
            }
          }
        }
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
        :from_date,
        :to_date
      )
    end
end
